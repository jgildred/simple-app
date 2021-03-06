public class SimpleApp : Gtk.Application {
    public SimpleApp () {
        Object (
            application_id: "com.github.jgildred.simple-app",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    
    protected override void activate () {
        var quit_action = new SimpleAction ("quit", null);

        add_action (quit_action);
        set_accels_for_action ("app.quit",  {"<Control>q", "<Control>w"});
        
        var close_button = new Gtk.Button.from_icon_name ("process-stop", Gtk.IconSize.LARGE_TOOLBAR) {
            action_name = "app.quit",
            tooltip_markup = Granite.markup_accel_tooltip (
                get_accels_for_action ("app.quit"),
                "Quit"
            )
        };
        var headerbar = new Gtk.HeaderBar () {
            show_close_button = true
        };
        headerbar.add (close_button);
    
        var hello_button = new Gtk.Button.with_label (_("Say Hello"));
        var hello_label = new Gtk.Label (null);

        var rotate_button = new Gtk.Button.with_label (_("Rotate"));
        var rotate_label = new Gtk.Label (_("Horizontal"));
        
        var grid = new Gtk.Grid () {
            column_spacing = 6,
            row_spacing = 6
        };
        
        var main_window = new Gtk.ApplicationWindow (this) {
            default_height = 300,
            default_width = 300,
            title = _("Simple App")
        };
        
        // add first row of widgets
        grid.attach (hello_button, 0, 0, 1, 1);
        grid.attach_next_to (hello_label, hello_button, Gtk.PositionType.RIGHT, 1, 1);

        // add second row of widgets
        grid.attach (rotate_button, 0, 1);
        grid.attach_next_to (rotate_label, rotate_button, Gtk.PositionType.RIGHT, 1, 1);

        main_window.add (grid);
        main_window.set_titlebar (headerbar);
        
        hello_button.clicked.connect (() => {
            hello_label.label = _("Noice!");
            hello_button.sensitive = false;
            var notification = new Notification (_("Simple App"));
            notification.set_icon (new ThemedIcon ("process-completed"));
            notification.set_body (_("The button was pressed!"));
            notification.add_button (_("Quit"), "app.quit");
            send_notification ("com.github.jgildred.simple-app", notification);
        });

        rotate_button.clicked.connect (() => {
            rotate_label.angle = 90;
            rotate_label.label = _("Vertical");
            rotate_button.sensitive = false;
        });
        
        main_window.show_all ();
        
        quit_action.activate.connect ( () => {
            main_window.destroy ();
        });
    }
    
    public static int main (string[] args) {
        return new SimpleApp ().run (args);
    }
}
