file_index_control = "<h3>Modulos disponibles</h3>
<ul>
	<li><a href=\"/control/eventos\">lorem ipsum</a></li>
	<li><a href=\"/control/algo\">Lorem ipsum 2</a></li>	
</ul>"


file_to_save = File.new("../application/views/control/control_index.php", "w+")
if file_to_save
   file_to_save.syswrite(file_index_control)
else
   puts "Unable to open file!"
end
