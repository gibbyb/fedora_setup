/* Gnome Shell Override
 *
 * Copyright (C) 2021 Sundeep Mediratta (smedius@gmail.com)
 * Copyright (C) 2020 Sergio Costas (rastersoft@gmail.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
/* exported GnomeShellOverride */
const { Meta, Clutter, GLib } = imports.gi;

var WorkspaceAnimation = null;
try {
    WorkspaceAnimation = imports.ui.workspaceAnimation;
} catch (err) {
    log('Workspace Animation does not exist');
}

var replaceData = {};
var workSpaceSwitchTimeoutID = null;

/*
     * This class overrides methods in the Gnome Shell. The new methods
     * need to be defined below the class as seperate functions.
     * The old methods that are overriden can be accesed by relpacedata.old_'name-of-replaced-method'
     * in the new functions
    */


var GnomeShellOverride = class {
    constructor() {
        this._isX11 = !Meta.is_wayland_compositor();
    }

    enable() {
        if (WorkspaceAnimation) {
            this.replaceMethod(WorkspaceAnimation.WorkspaceGroup, '_shouldShowWindow', newShouldShowWindow);
            this.replaceMethod(WorkspaceAnimation.WorkspaceAnimationController, '_finishWorkspaceSwitch', newFinishWorkspaceSwitch);
        }
    }

    // restore external methods only if have been intercepted

    disable() {
        if (workSpaceSwitchTimeoutID) {
            GLib.Source.remove(workSpaceSwitchTimeoutID);
            workSpaceSwitchTimeoutID = null;
        }
        for (let value of Object.values(replaceData)) {
            if (value[0])
                value[1].prototype[value[2]] = value[0];
        }
        replaceData = {};
    }

    /**
     * Replaces a method in a class with our own method, and stores the original
     * one in 'replaceData' using 'old_XXXX' (being XXXX the name of the original method),
     * or 'old_classId_XXXX' if 'classId' is defined. This is done this way for the
     * case that two methods with the same name must be replaced in two different
     * classes
     *
     * @param {class} className The class where to replace the method
     * @param {string} methodName The method to replace
     * @param {Function} functionToCall The function to call as the replaced method
     * @param {string} [classId] an extra ID to identify the stored method when two
     *                           methods with the same name are replaced in
     *                           two different classes
     */

    replaceMethod(className, methodName, functionToCall, classId) {
        if (classId)
            replaceData[`old_${classId}_${methodName}`] = [className.prototype[methodName], className, methodName, classId];
        else
            replaceData[`old_${methodName}`] = [className.prototype[methodName], className, methodName];

        className.prototype[methodName] = functionToCall;
    }
};


/**
 * New Functions used to replace the gnome shell functions are defined below.
 */

/**
 * Method replacement for should_show_window
 * Adds the desktop window to the background if it is not on that workspace, removes from _syncstack
 * Therefore while switching workspaces with gestures, it appears the icons are already there.
 *
 * @param {Meta.Window} window the window
 */
function newShouldShowWindow(window) {
    if (window.customJS_ding && this._workspace) {
        if (!this.dingClone) {
            const geometry = global.display.get_monitor_geometry(this._monitor.index);
            const [intersects] = window.get_frame_rect().intersect(geometry);
            if (intersects && this._background) {
                this.dingClone = new Clutter.Clone({
                    source: window.actor,
                    x: window.actor.x - this._monitor.x,
                    y: window.actor.y - this._monitor.y,
                });
                this._background.add_child(this.dingClone);
            }
        }
        return false;
    }
    return replaceData.old__shouldShowWindow[0].apply(this, [window]);
}

/**
 * Method replacement for finishWorkspaceSwitch
 * Adds a delay before destroying the moving window
 * To give time for the DING window to move to the new Workspace behind the moving window.
 * To prevent flickering of icons.
 *
 * @param {object} switchData the original switchData for the function
 */
function newFinishWorkspaceSwitch(switchData) {
    let movingWindow = this.movingWindow;
    let mymonitorGroup = switchData.monitors;
    let dummyMonitor = Clutter.Actor.new();
    switchData.monitors = [dummyMonitor];

    replaceData.old__finishWorkspaceSwitch[0].apply(this, [switchData]);

    workSpaceSwitchTimeoutID = GLib.timeout_add(GLib.PRIORITY_DEFAULT, 50, () => {
        mymonitorGroup.forEach(m => m.destroy());
        movingWindow = null;
        workSpaceSwitchTimeoutID = null;
        return false;
    });
}
