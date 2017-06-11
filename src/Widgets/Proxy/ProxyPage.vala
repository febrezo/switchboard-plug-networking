/*-
 * Copyright (c) 2015-2016 elementary LLC.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Adam Bieńkowski <donadigos159@gmail.com>
 */

namespace Network.Widgets {
    public class ProxyPage : Page {
        public signal void update_status_label (string mode);

        private Gtk.Stack stack;

        construct {
            title = _("Proxy");
            icon_name = "preferences-system-network";

            column_spacing = 12;
            row_spacing = 12;
            margin = 24;
            margin_bottom = 12;

            var configuration_page = new ConfigurationPage ();
            var exceptions_page = new ExecepionsPage ();

            control_switch.bind_property ("active", configuration_page, "sensitive", BindingFlags.SYNC_CREATE);
            control_switch.bind_property ("active", exceptions_page, "sensitive", BindingFlags.SYNC_CREATE);

            stack = new Gtk.Stack ();
            stack.add_titled (configuration_page, "configuration", _("Configuration"));
            stack.add_titled (exceptions_page, "exceptions", _("Exceptions"));

            var stackswitcher = new Gtk.StackSwitcher ();
            stackswitcher.halign = Gtk.Align.CENTER;
            stackswitcher.stack = stack;

            var proxy_settings = ProxySettings.get_default ();
            proxy_settings.changed.connect (update);
            update ();

            add (stackswitcher);
            add (stack);

            show_all ();

            stack.visible_child = configuration_page;
        }

        protected override void control_switch_activated () {
            if (!control_switch.active) {
                var proxy_settings = ProxySettings.get_default ();
                proxy_settings.mode = "none";
            }
        }

        protected override void update () {
            var proxy_settings = ProxySettings.get_default ();
            switch (proxy_settings.mode) {
                case "none":
                    control_switch.active = false;
                    break;
                case "manual":
                case "auto":                
                    control_switch.active = true;
                    break;
                default:
                    break;
            }
        }
    }
}
