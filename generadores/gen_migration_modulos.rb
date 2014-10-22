migration_modulos = "<?php defined('BASEPATH') OR exit('No direct script access allowed');  
 
class Migration_Create_Modulos extends CI_Migration
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
            \"nombre\"            =>        array(
                \"type\"                =>        \"VARCHAR\",
                \"constraint\"          =>        250,
            )
            )
            );
 
        $this->dbforge->add_key('id', TRUE); //ID como primary_key
        $this->dbforge->create_table('modulos');//crea la tabla

        $data_modulo1 = array(
            \"nombre\"        =>        \"permisos\",
        );
        $data_modulo2 = array(
            \"nombre\"        =>        \"roles\",
        );
        $data_modulo3 = array(
            \"nombre\"        =>        \"usuarios\",
        );



        //ingresamos el registro en la base de datos
        $this->db->insert(\"modulos\", $data_modulo1);
        $this->db->insert(\"modulos\", $data_modulo2);
        $this->db->insert(\"modulos\", $data_modulo3);


    }
 
    public function down()
    {
        //ELIMINAR TABLA
        $this->dbforge->drop_table('modulos');
 
    }
}
?>"

file_migration_modulos = File.new("../application/migrations/004_create_modulos.php", "w+")
if file_migration_modulos
   file_migration_modulos.syswrite(migration_modulos)
else
   puts "Unable to open file!"
end