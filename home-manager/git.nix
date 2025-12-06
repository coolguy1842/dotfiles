{...}: {
    programs.git = {
        enable = true;
        
        settings = {
            user = {
                name = "coolguy1842";
                email = "github.com.freely529@passfwd.com";
            };
            
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
