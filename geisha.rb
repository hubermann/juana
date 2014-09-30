#Version 1.0
#Autor: Gabriel Hubermann | @hubermann | hubermann@gmail.com
#Fecha: 20/08/2014
#licencia: "Hace lo que se te cante"
=begin

objetivo: tirar dentro de una carpeta de instalacion de codeigniter y usar este scrip desde consola para la 
configuracion de datos basicos + creacion de modelos + vistas + formularios, etc.

=end


#funcion que comprueba si un directorio existe
def directory_exists?(directory)
  File.directory?(directory)
end

def create_folder(new_folder_name)
	status = "Nueva carpeta "+new_folder_name
	if directory_exists?(new_folder_name)
	status = "Carpeta "+new_folder_name+" ya existe."
	else
		#creo carpeta para migraciones
		if !Dir.mkdir new_folder_name
			status = "Error al crear "+new_folder_name+"."
		end
	end
	puts status
end

def replace_config(file_to_edit, string_A, string_B)
	status =  "No encontrado "+string_A
	File.open(file_to_edit) do |f|
	  	f.each_line do |line|
	  		if line.include? string_A
   				config_file = File.read(file_to_edit)
				replace = config_file.gsub!(string_A, string_B)
				File.open(file_to_edit, "w") { |file| file.puts replace }
				status = "Reemplazada "+string_A
			end
	  	end
	end
	puts status
end

base_url = ""
if base_url.length < 6
	puts "¿Cual es la base_url? (algo como http://urllocal:8888)"  
	STDOUT.flush  
	base_url = gets.chomp  
	puts "La url del desarrollo es " + base_url
end

nombre_bd = ""
if nombre_bd.length < 2
	puts "BD nombre?"  
	STDOUT.flush  
	nombre_bd = gets.chomp  
	#puts "La url del desarrollo es " + base_url
end

user_bd = ""
if user_bd.length < 2
	puts "User BD?"  
	STDOUT.flush  
	user_bd = gets.chomp  
	#puts "La url del desarrollo es " + base_url
end

pass_bd = ""
if pass_bd.length < 2
	puts "Pass BD?"  
	STDOUT.flush  
	pass_bd = gets.chomp  
	#puts "La url del desarrollo es " + base_url
end

encryption_key = (0...35).map { ('a'..'z').to_a[rand(26)] }.join


#carpeta migraciones
create_folder("../application/migrations")

#carpeta publica
create_folder("../public_folder")

#CONFIG FILE
config_file = "../application/config/config.php"

#base Url
replace_config(config_file, "$config['base_url']	= '';", "$config['base_url']	= '"+base_url+"';")
#indexpage
replace_config(config_file, "$config['index_page'] = 'index.php';", "$config['index_page'] = '';")

#gen modal view for login 
load "generadores/gen_htaccess.rb"


#encryption key
replace_config(config_file, "$config['encryption_key'] = '';", "$config['encryption_key']  = '"+encryption_key+"';")

#AUTOLOAD
autoload_file = "../application/config/autoload.php"
replace_config(autoload_file, "$autoload['libraries'] = array();", "$autoload['libraries'] = array('database', 'session');")

#MIGRATION
migration_file = "../application/config/migration.php"
replace_config(migration_file, "$config['migration_enabled'] = FALSE;", "$config['migration_enabled'] = TRUE;")

#ROUTES  (FIRST WRITE)
routes_file = "../application/config/routes.php"
replace_config(routes_file, "/* End of file routes.php */", "$route['control'] = 'dashboard';\n$route['control/logout'] = 'dashboard/logout';\n/* append */")
replace_config(routes_file, "/* append */", "$route['migrate/(:num)'] = 'migrate/index/$';\n/* append */")
#desde aca se agregan las nuevas lineas en /* append */

#DB
database_file = "../application/config/database.php"
replace_config(database_file, "$db['default']['username'] = '';", "$db['default']['username'] = '#{user_bd}';")
replace_config(database_file, "$db['default']['password'] = '';", "$db['default']['password'] = '#{pass_bd}';")
replace_config(database_file, "$db['default']['database'] = '';", "$db['default']['database'] = '#{nombre_bd}';")


#gen controller migration
load "generadores/gen_migration_c.rb"
file_count_migrations = File.new("count_migrations.rb", "w+")
if file_count_migrations
   file_count_migrations.syswrite("@qty_migrations = 2")
else
   puts "Unable to open file!"
end


#gen controller migration
load "generadores/gen_dashboard_c.rb"

#gen model useradmin
load "generadores/gen_dashboard_m.rb"

#gen migration useradmin
load "generadores/gen_migration_useradmin.rb"

#carpeta backend
create_folder("../application/controllers/control")

#carpeta backend
create_folder("../application/views/control")

#gen login for backend
load "generadores/gen_login_v.rb"
#gen modal view for login 
load "generadores/gen_modal_layout_v.rb"
#gen modal view control layout 
load "generadores/gen_control_layout_v.rb"


puts "End | Ahora puede usarse padawan.rb para crear modelos."