migration_imagenes = "<?php defined('BASEPATH') OR exit('No direct script access allowed');  
 
class Migration_Create_Imagenes_#{@plural.capitalize} extends CI_Migration
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
 
                ),\"#{@singular}_id\"    		=>        array(
                    \"type\"                =>        \"INT\",
                    \"constraint\"        	=>        11,
                ),
                \"filename\"    		=>        array(
                    \"type\"                =>        \"TEXT\",
                    \"constraint\"        	=>        100,
                ),
            )
        );
 
        $this->dbforge->add_key('id', TRUE); //ID como primary_key
        $this->dbforge->create_table('imagenes_#{@plural}');//crea la tabla
    }
 
    public function down()
    {
        //ELIMINAR TABLA
        $this->dbforge->drop_table('imagenes_#{@plural}');
 
    }
}
?>"
#verifico la cantidad de archvos de migracion
dir_migrations = '../application/migrations'
cantidad  = Dir[File.join(dir_migrations, '**', '*')].count { |file| File.file?(file) }
cantidad = cantidad + 1

file_migration_imagenes = File.new("../application/migrations/00#{cantidad}_create_imagenes_#{@plural}.php", "w+")
if file_migration_imagenes
   file_migration_imagenes.syswrite(migration_imagenes)
else
   puts "Unable to open file!"
end
