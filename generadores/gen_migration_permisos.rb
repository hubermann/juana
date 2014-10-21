migration_permisos = "<?php defined('BASEPATH') OR exit('No direct script access allowed');  
 
class Migration_Create_Permisos extends CI_Migration
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
                \"default\"               =>  0

            ),
            \"role_id\"           =>        array(
                \"type\"                =>        \"INT\",
                \"constraint\"            =>        2,
            ),

            \"modulo\"            =>        array(
                \"type\"                =>        \"VARCHAR\",
                \"constraint\"            =>        100,
            ),

            \"url\"           =>        array(
                \"type\"                =>        \"VARCHAR\",
                \"constraint\"            =>        100,
            ),

            \"permiso\"           =>        array(
                \"type\"                =>        \"INT\",
                \"constraint\"            =>        1,
            ),

            )
            );
 
        $this->dbforge->add_key('id', TRUE); //ID como primary_key
        $this->dbforge->create_table('permisos');//crea la tabla

         //creamos un array con los datos del usuario
        $data_permisos = array(
            \"role_id\"        =>        \"1\",
            \"modulo\"        =>        \"1\",
            \"permiso\"        =>        \"1\"
        );
        //ingresamos el registro en la base de datos
        $this->db->insert(\"permisos\", $data_permisos);
    }
 
    public function down()
    {
        //ELIMINAR TABLA
        $this->dbforge->drop_table('permisos');
 
    }
}
?>"

file_migration_permisos = File.new("../application/migrations/002_create_permisos.php", "w+")
if file_migration_permisos
   file_migration_permisos.syswrite(migration_permisos)
else
   puts "Unable to open file!"
end