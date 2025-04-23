{...}: {
    programs.git = {
        enable = true;
        
        userName = "coolguy1842";
        userEmail = "github.com.freely529@passfwd.com";

        extraConfig = {
            init.defaultBranch = "main";
            
            color = {
                ui = "auto";
            };
            
            push = {
                default = "simple";
            };
        };
    };
}
