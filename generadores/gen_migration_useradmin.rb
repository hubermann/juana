migration_useradmin = "<?php defined('BASEPATH') OR exit('No direct script access allowed');  
 
class Migration_Create_Useradmin extends CI_Migration
{
    public function up()
    {
        //TABLA Useradmin
        $this->dbforge->add_field(
            array(
                \"id\"        =>        array(
                    \"type\"                =>        \"INT\",
                    \"constraint\"        =>        11,
                    \"unsigned\"            =>        TRUE,
                    \"auto_increment\"    =>        TRUE,
 
                ),
                \"email\"    =>        array(
                    \"type\"                =>        \"VARCHAR\",
                    \"constraint\"        =>        100,
                ),
                \"password\"    =>        array(
                    \"type\"                =>        \"VARCHAR\",
                    \"constraint\"        =>        100,
                ),
            )
        );
 
        $this->dbforge->add_key('id', TRUE); //ID como primary_key
        $this->dbforge->create_table('useradmin');//crea la tabla

        //creamos un array con los datos del usuario
        $data_useradmin = array(
            \"email\"        =>        \"admin\",
            \"password\"        =>        \"plokij\"
        );
        //ingresamos el registro en la base de datos
        $this->db->insert(\"useradmin\", $data_useradmin);

    }
 
    public function down()
    {
        //ELIMINAR TABLA
        $this->dbforge->drop_table('useradmin');
 
    }
}
?>"

file_migration_useradmin = File.new("../application/migrations/001_create_useradmin.php", "w+")
if file_migration_useradmin
   file_migration_useradmin.syswrite(migration_useradmin)
else
   puts "Unable to open file!"
end