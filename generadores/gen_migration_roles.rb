migration_roles = "<?php defined('BASEPATH') OR exit('No direct script access allowed');  
 
class Migration_Create_Roles extends CI_Migration
{
    public function up()
    {
        //TABLA 
        $this->dbforge->add_field(
            array(
                \"id\"        =>        array(
                    \"type\"                =>        \"INT\",
                    \"constraint\"        =>        11,
                    \"unsigned\"            =>        TRUE,
                    \"auto_increment\"    =>        TRUE,
 
                ),
                \"status\"        =>        array(
                    \"type\"                =>        \"INT\",
                    \"constraint\"          =>        1,
 
                ),
                  \"nombre\"          =>        array(
                    \"type\"                =>        \"VARCHAR\",
                    \"constraint\"            =>        100,
                ),
    
            )
        );
 
        $this->dbforge->add_key('id', TRUE); //ID como primary_key
        $this->dbforge->create_table('roles');//crea la tabla

         //creamos un array con los datos del usuario
        $data_useradmin = array(
            \"nombre\"        =>        \"Administrador\"
        );
        //ingresamos el registro en la base de datos
        $this->db->insert(\"roles\", $data_useradmin);
    }
 
    public function down()
    {
        //ELIMINAR TABLA
        $this->dbforge->drop_table('roles');
 
    }
}
?>"

file_migration_roles = File.new("../application/migrations/003_create_roles.php", "w+")
if file_migration_roles
   file_migration_roles.syswrite(migration_roles)
else
   puts "Unable to open file!"
end