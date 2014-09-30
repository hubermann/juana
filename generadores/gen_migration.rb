migration_output = "<?php defined('BASEPATH') OR exit('No direct script access allowed');  
 
class Migration_Create_#{@plural.capitalize} extends CI_Migration
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
 
                ),"

@campos_clean.each do |campo|
	migration_output <<"
					\"#{campo}\"    		=>        array(
                    \"type\"                =>        \"TEXT\",
                    \"constraint\"        	=>        100,
                ),
	"
end 
                


migration_output <<"
            )
        );
 
        $this->dbforge->add_key('id', TRUE); //ID como primary_key
        $this->dbforge->create_table('#{@plural}');//crea la tabla
    }
 
    public function down()
    {
        //ELIMINAR TABLA
        $this->dbforge->drop_table('#{@plural}');
 
    }
}
?>"

#verifico la cantidad de archvos de migracion
dir_migrations = '../application/migrations'
cantidad  = Dir[File.join(dir_migrations, '**', '*')].count { |file| File.file?(file) }
cantidad = cantidad + 1

file_migration = File.new("../application/migrations/00#{cantidad}_create_#{@plural}.php", "w+")
if file_migration
   file_migration.syswrite(migration_output)
else
   puts "Unable to open file!"
end
