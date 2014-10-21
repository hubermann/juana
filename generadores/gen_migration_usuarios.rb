migration_usuarios = "<?php defined('BASEPATH') OR exit('No direct script access allowed');  
 
class Migration_Create_Usuarios extends CI_Migration
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
                \"default\"           =>            0,

            ),
            \"nombre\"          =>        array(
                \"type\"                =>        \"TEXT\",
                \"constraint\"          =>        100,
            ),

            \"apellido\"            =>        array(
                \"type\"                =>        \"TEXT\",
                \"constraint\"          =>        100,
            ),

            \"email\"           =>        array(
                \"type\"                =>        \"TEXT\",
                \"constraint\"          =>        100,
            ),

            \"password\"            =>        array(
                \"type\"                =>        \"VARCHAR\",
                \"constraint\"          =>        250,
            ),

            \"salt\"            =>        array(
                \"type\"                =>        \"VARCHAR\",
                \"constraint\"          =>        100,
            ),

            \"role_id\"         =>        array(
                \"type\"                =>        \"INT\",
                \"constraint\"          =>        2,
            ),

            \"created_at\"          =>        array(
                \"type\"                =>        \"DATETIME\",
            ),

            \"updated_at\"          =>        array(
                \"type\"                =>        \"DATETIME\",

            ),

            \"filename\"            =>        array(
                \"type\"                =>        \"VARCHAR\",
                \"constraint\"          =>        255,
            ),

            )
            );
 
        $this->dbforge->add_key('id', TRUE); //ID como primary_key
        $this->dbforge->create_table('usuarios');//crea la tabla

        $data_user = array(
            \"nombre\"        =>        \"super\",
            \"apellido\"        =>        \"user\",
            \"email\"        =>        \"admin@mail.com\",
            \"password\"        =>        \"d715e5d5f7449f8914cf7f19ea8643ba4814cc7f13853785f910ca6beb13aa0b860f7856b50790231c1b21a168d81308cf389d8605c75e3c9eabff3e4f0966a2\",
            \"salt\"        =>        \"963da0c4b89504217d036a315c1b88c2\",
            \"role_id\"        =>        \"1\",
        );

        //ingresamos el registro en la base de datos
        $this->db->insert(\"usuarios\", $data_user);


    }
 
    public function down()
    {
        //ELIMINAR TABLA
        $this->dbforge->drop_table('usuarios');
 
    }
}
?>"

file_migration_usuarios = File.new("../application/migrations/001_create_usuarios.php", "w+")
if file_migration_usuarios
   file_migration_usuarios.syswrite(migration_usuarios)
else
   puts "Unable to open file!"
end