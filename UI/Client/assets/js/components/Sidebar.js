const Sidebar = {
  init() {
    const sidebar = jQuery("#main-sidebar");

    if (sidebar) {
      $("#header-toogle-menu-icon").click(function() {
        sidebar.toggleClass("show");
      });

      $("#header-toogle-menu-icon-2").click(function() {
        sidebar.toggleClass("show");
      });

      const overlay = jQuery("#main-sidebar .overlay");

      if (overlay) {
        overlay.click(function() {
          sidebar.toggleClass("show");
        });
      }
    }
  },
};

export default Sidebar;
