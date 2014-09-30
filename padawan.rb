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
	if directory_exists?(new_folder_name)
	puts "Carpeta "+new_folder_name+" ya existe."
	else
		#creo carpeta para migraciones
		if !Dir.mkdir new_folder_name
			puts "Error al crear "+new_folder_name+"."
		end
	end
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


def confirmacion(plural,singular,imagenes, campos_clean)
	if plural.length > 3 || singular.length > 3 || campos_clean.length > 1
	puts "pareceria estar todo ok, confirma? - YES - NO"
	STDOUT.flush
	confirmacion = gets.chomp
		if confirmacion == "YES"
			#envio todo a la funcion encargada de crear el modelo en general
			create_folder("../application/views/control/#{plural}")
			creator_model( plural, singular, imagenes, campos_clean )
		elsif confirmacion == "NO"
			recolector
		else
			puts "Debe ingresar YES o NO"
			confirmacion(plural, singular, imagenes, campos_clean)
		end
	end
end


def creator_model(plural,singular,imagenes, campos_clean)

	#Paso datos a variables de instancia para ser accesibles desde los requiere
	@plural = plural
	@singular = singular
	@imagenes = imagenes
	@campos_clean = campos_clean



	#MIGRACION
	require "./generadores/gen_migration.rb"

	#MIGRACION IMAGENES
	if imagenes == "2"
		require "./generadores/gen_migration_imagenes.rb"
		#MODELO DE LAS IMAGENES ASOCIADAS
		require "./generadores/gen_model_imagenes.rb"
		#CARPETA IMAGENES
		create_folder("../images-#{@plural}")

		#agregar al htacces la carpeta reemplazando \#*****\#
		htaccess_file = "../.htaccess"
		replace_config(htaccess_file, "#*****#", "images-#{@plural}|\#*****#")
	end

	if imagenes == "1"
		#CARPETA IMAGENES
		create_folder("../images-#{@plural}")
		#agregar al htacces la carpeta reemplazando \#*****\#
		htaccess_file = "../.htaccess"
		replace_config(htaccess_file, "#*****#", "images-#{@plural}|\#*****#")

	end

	# MODELO
	require "./generadores/gen_model.rb"

	# CONTROLLER
	require "./generadores/gen_controller_backend.rb"

	# VIEWS
	require "./generadores/gen_views_backend.rb"
	
	# Ruta para el paginado del modelo
	routes_file = "../application/config/routes.php"
	replace_config(routes_file, "/* append */", "$route['control/#{plural}/(:num)'] = 'control/#{plural}/index/$';\n/* append */")
	

end



def recolector
	#### MODELO EN PLURAL
	puts "Nombre del modelo en plural:"  
	STDOUT.flush  
	plural = gets.chomp  
	puts "plural es: " + plural

	#### MODELO EN SINGULAR
	puts "Nombre del modelo en singular:"  
	STDOUT.flush  
	singular = gets.chomp  
	puts "singular es: " + singular

	#### REQUIERE IMAGENES?
	puts "El modelo no requiere adjuntos (files/imagenes) = 0 \nEl modelo requiere un adjunto individual por item = 1 \nEl modelo requiere multiple adjuntos = 2"  
	STDOUT.flush  
	imagenes = gets.chomp  
	puts "imagenes: " + imagenes

	#### CAMPOS DEL MODELO
	puts "campos del modelo? (separados por coma, no es necesario el campo ID)"
	#Si hay UN adjunto
	if imagenes == "1"
		 puts "Se agregara automaticamente un campo <<filename>> para el adjunto."
	end
	#Si requiere mas de un adjunto hacer modelo y controller para tal fin##################
	STDOUT.flush  
	campos = gets.chomp  
	listado = campos.split(",")

	campos_clean = Array.new()
	listado.each do |campo|
		campos_clean << campo.strip
	end
	#si hay UN adjunto agrego campo filename
	if imagenes == "1"
		 campos_clean << "filename"
	end


	confirmacion( plural, singular, imagenes, campos_clean )
end


#comienza recoleccion de datos
recolector

#limpio el htaccess
htaccess_file = "../.htaccess"
replace_config(htaccess_file, "#*****#", "")

puts "fin script."
