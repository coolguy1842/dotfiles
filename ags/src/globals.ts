import { OptionsHandler } from "./utils/handlers/optionsHandler";
import { StyleHandler } from "./utils/handlers/styleHandler";
import { IReloadable } from "./interfaces/reloadable";
import { generateOptions } from "./options/options";

import { Variable } from "resource:///com/github/Aylur/ags/variable.js";

import { PopupWindow } from "./utils/classes/PopupWindow";
import { createSystemTrayPopupWindow } from "./popups/SystemTrayPopupWindow";
import { createAppLauncherPopupWindow, toggleAppLauncherPopupWindow } from "./popups/AppLauncherPopupWindow";
import { createQuickMenuPopupWindow } from "./popups/QuickMenuPopupWindow";
import { getCurrentMonitor } from "./utils/utils";


import GLib from "gi://GLib";
import Gio from "gi://Gio";
import Gdk from "gi://Gdk";
import Gtk from "gi://Gtk?version=3.0";
import GObject from "@girs/gobject-2.0/gobject-2.0";

const TEMP_DIR_S = `/tmp/coolguy/ags`;

const STYLES_DIR_S = `${App.configDir}/styles`;
const OPTIONS_DIR_S = `${App.configDir.split("/").slice(0, -1).join("/")}/agsoptions`;
const OUT_CSS_DIR_S = `${TEMP_DIR_S}/css`;

export class Globals implements IReloadable {
    private _loaded: boolean = false;

    get loaded() { return this._loaded }
    set loaded(loaded: boolean) {
        if(this._loaded == loaded) return;
        
        if(loaded) this.load();
        else this.cleanup();
    } 

    private _monitorLookups?: { [name: string]: number };
    private _paths = {
        TEMP_DIR: TEMP_DIR_S,
        OPTIONS_PATH: `${OPTIONS_DIR_S}/options.json`,
        SOCKET_PATH: `${TEMP_DIR_S}/socket`,
        
        STYLES_DIR: STYLES_DIR_S,
        STYLES_MAIN: `${STYLES_DIR_S}/main.scss`,
    
        OUT_CSS_DIR: `${TEMP_DIR_S}/css`,
        OUT_SCSS_DYNAMIC: `${OUT_CSS_DIR_S}/dynamic.scss`,
        OUT_SCSS_IMPORTS: `${OUT_CSS_DIR_S}/imports.scss`,
        OUT_CSS_IMPORTS: `${OUT_CSS_DIR_S}/imports.css`
    };

    private _clock?: Variable<GLib.DateTime>;
    private _searchInput?: Variable<string>;

    private _optionsHandler?: OptionsHandler<ReturnType<typeof generateOptions>>;
    private _styleHandler?: StyleHandler;

    private _communicationSocketService?: Gio.SocketService;
    private _communicationSocket?: Gio.Socket;

    private _iconTheme?: Gtk.IconTheme;

    private _popupWindows?: {
        SystemTrayPopupWindow: ReturnType<typeof createSystemTrayPopupWindow>,
        AppLauncherPopupWindow: ReturnType<typeof createAppLauncherPopupWindow>,
        QuickMenuPopupWindow: ReturnType<typeof createQuickMenuPopupWindow>
    };

    private _close_socket(path: string) {
        const file = Gio.File.new_for_path(path);

        if(file.query_exists(null)) {
            file.delete(null);
        }
    }

    private _on_socket_message(socket: Gio.SocketService, connection: Gio.SocketConnection, channel: GObject.Object | null) {
        const inStream = connection.get_input_stream();
        const message = inStream.read_bytes(128, null);

        const command = new TextDecoder().decode(message.toArray());

        switch(command) {
        case "app_launcher":
            toggleAppLauncherPopupWindow(getCurrentMonitor());
            break;
        default: break;
        }
        
        connection.close(null);
    }

    
    loadMonitorLookups() {
        // not fully tested, allows for monitors to be added and removed and shows on the right monitor properly
        const screen = Gdk.Screen.get_default();
        if(screen == undefined) {
            this._monitorLookups = {};
            return;
        }

        const monitors = screen.get_n_monitors();

        const monitorLookups: { [ name: string ]: number } = {};
        for(var id = 0; id < monitors; id++) {
            const name = screen.get_monitor_plug_name(id) ?? undefined;

            if(name) {
                monitorLookups[name] = id;
            }
        }

        this._monitorLookups =  monitorLookups;
    }


    load(): void {
        if(this._loaded) return;

        this.loadMonitorLookups();
        
        this._searchInput = new Variable("");
        this._clock = new Variable(GLib.DateTime.new_now_local(), {
            poll: [1000, () => GLib.DateTime.new_now_local()],
        });

        var file = Gio.File.new_for_path(OPTIONS_DIR_S);
        if(!file.query_exists(null)) {
            file.make_directory(null);
        }

        this._optionsHandler = new OptionsHandler(generateOptions);
        this._optionsHandler.load();

        this._styleHandler = new StyleHandler();
        this._styleHandler.load();

        this._popupWindows = {
            SystemTrayPopupWindow: createSystemTrayPopupWindow(),
            AppLauncherPopupWindow: createAppLauncherPopupWindow(),
            QuickMenuPopupWindow: createQuickMenuPopupWindow()
        };

        for(const window of Object.values(this._popupWindows) as PopupWindow<any, unknown>[]) {
            window.load();
        }

        // probably not ideal but it doesnt seem to cleanup properly
        this._close_socket(this._paths.SOCKET_PATH);
        
        const addressPath = this._paths.SOCKET_PATH;
        const address = Gio.UnixSocketAddress.new(addressPath);

        this._communicationSocketService = Gio.SocketService.new();
        this._communicationSocketService.add_address(address, Gio.SocketType.STREAM, Gio.SocketProtocol.DEFAULT, null);

        this._communicationSocketService.connect("incoming", this._on_socket_message);
        this._communicationSocketService.start();


        // load icon path
        const iconPath = `${App.configDir}/icons`;
        const defaultTheme = Gtk.IconTheme.get_default();

        this._iconTheme = Gtk.IconTheme.new();
        
        this._iconTheme.add_resource_path(iconPath);
        this._iconTheme.set_search_path([ ...defaultTheme.get_search_path(), `${iconPath}/symbolic/emblems` ]);

        this._loaded = true;
    }

    cleanup(): void {
        if(!this._loaded) return;
        
        for(const window of Object.values(this._popupWindows ?? {}) as PopupWindow<any, unknown>[]) {
            window.cleanup();
            window.window.destroy();
        }

        this._popupWindows = undefined;

        this._styleHandler?.cleanup();
        this._optionsHandler?.cleanup();

        this._searchInput = undefined;
        this._clock = undefined;

        this._communicationSocketService = undefined;
        if(this._paths?.SOCKET_PATH) {
            this._close_socket(this._paths.SOCKET_PATH);
        }

        this._monitorLookups = undefined;

        this._loaded = false;
    }


    get monitorLookups() { return this._monitorLookups; }
    get paths() { return this._paths; }

    get clock() { return this._clock; }
    get searchInput() { return this._searchInput; }

    get optionsHandler() { return this._optionsHandler; }
    get styleHandler() { return this._styleHandler; }

    get popupWindows() { return this._popupWindows; }

    get communicationSocket() { return this._communicationSocket; }

    get iconTheme() { return this._iconTheme; }
};

export const globals = new Globals();