controller_dashboard = "<!DOCTYPE html>
<html lang=\"en\">
  <head>
    <meta charset=\"utf-8\">
    <title></title>
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <meta name=\"description\" content=\"\">
    <meta name=\"author\" content=\"\">

    <!-- Le styles -->
    <link href=\"<?php echo base_url('/public_folder/assets/css/bootstrap.css'); ?>\" rel=\"stylesheet\">
    <style type=\"text/css\">
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }

      .form-signin {
      font-family: Helvetica;
        max-width: 280px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type=\"text\"],
      .form-signin input[type=\"password\"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px; width: 100%; padding: .5em;
      }
      .alert{width: 85%; margin: 1.5em auto; text-align: center;}
		.form-signin button{
			width: 100%; padding: .8em;
		}
    </style>
    

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src=\"../assets/js/html5shiv.js\"></script>
    <![endif]-->


  </head>

  <body>

    <div class=\"container\">
<?php 
$attribute = Array (\"class\"=>\"form-signin\");
echo form_open(base_url().'dashboard/login',$attribute); ?>

        <h4 class=\"form-signin-heading\">Ok, probemos de acceder!</h4>
        <input type=\"text\" class=\"input-block-level\" placeholder=\"Email\" name=\"email\" value=\"<?php echo set_value('email'); ?>\">
     
        <?php echo form_error('email','<p class=\"error\">', '</p>'); ?>
        
        <input type=\"password\" class=\"input-block-level\" placeholder=\"Password\" name=\"password\">
        <?php echo form_error('password','<p class=\"error\">', '</p>'); ?>
        <label class=\"checkbox\">
         <!-- <input type=\"checkbox\" value=\"remember-me\"> Remember me-->
        </label>
        <button class=\"btn btn-large \" type=\"submit\"><i class=\"icon-lock icon-large\"></i> Acceder</button>
<?php echo form_close(); ?>

    </div> <!-- /container -->



  </body>
</html>"

file_controller_dashboard = File.new("../application/views/control/login.php", "w+")
if file_controller_dashboard
   file_controller_dashboard.syswrite(controller_dashboard)
else
   puts "Unable to open file!"
end

