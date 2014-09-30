#ALL
all_file = "
<h2><?php echo $title; ?></h2>

<?php 
if(count($query->result())){
	echo '<table class=\"table table-striped\">';
	foreach ($query->result() as $row):

		/* $nombre_categoria = $this->categoria->traer_nombre($row->categoria_id); */

		echo '<tr>';\n"

@campos_clean.each do |campo|
	all_file << "echo '<td>'.$row->#{campo}.' </td>';\n"
end



if @imagenes =="1"
	all_file <<	"
		if($row->filename){
		echo '<img src=\"'.base_url('images-#{@plural}/'.$row->filename).'\" width=\"100\" />';
		}"
end
all_file <<	"
		echo '</td>';

		echo '<td> 
		<div class=\"btn-group\">
		<a class=\"btn btn-small\" href=\"'.base_url('control/#{@plural}/delete_comfirm/'.$row->id.'').'\">Eliminar</a>
		<a class=\"btn btn-small\" href=\"'.base_url('control/#{@plural}/editar/'.$row->id.'').'\">Editar</a>
		<!--<a class=\"btn btn-small\" href=\"'.base_url('control/#{@plural}/detail/'.$row->id.'').'\">detalle</a>-->
		</div>
		</td>';


		echo '</tr>';

	endforeach; 
	echo '</table>';
}else{
	echo 'No hay resultados.';
}
?>
<div>
<ul class=\"pagination pagination-small pagination-centered\">
<?php echo $pagination_links;  ?>
</ul>
</div>"



file_all_file = File.new("../application/views/control/#{@plural}/all.php", "w+")
if file_all_file
   file_all_file.syswrite(all_file)
else
   puts "Unable to open file! (view all)"
end

#CONFIRM DELETE
confirm_file ="<?php  
$attributes = array('class' => 'form-horizontal', 'id' => 'delete_#{@singular}');
echo form_open(base_url('control/#{@plural}/delete/'.$query->id), $attributes);
echo '<fieldset>'.form_hidden('id', $query->id); 

?>
<legend><?php echo $title ?></legend>
<div class=\"well well-large well-transparent\">
 <!-- <p>Categoria id: <?php \#echo $nombre_categoria = $this->categoria->traer_nombre($query->categoria_id); ?></p> -->\n
"


@campos_clean.each do |campo|
	confirm_file << " <p>#{campo.capitalize}: <?php echo $query->#{campo}; ?></p>\n"
end

confirm_file <<"
<!--  -->
<div class=\"control-group\">

<label class=\"checkbox inline\">

<input type=\"checkbox\" name=\"comfirm\" id=\"comfirm\" />
<p>Confirma eliminar?</p>
<?php echo form_error('comfirm','<p class=\"error\">', '</p>'); ?>
 </label>
</div>
<!--  -->
<div class=\"control-group\">
<button class=\"btn btn-danger\" type=\"submit\"><i class=\"icon-trash icon-large\"></i> Eliminar</button>
</div>


</fieldset>

<?php echo form_close(); ?>"

file_confirm = File.new("../application/views/control/#{@plural}/comfirm_delete.php", "w+")
if file_confirm
   file_confirm.syswrite(confirm_file)
else
   puts "Unable to open file! (confirm delete)"
end

#DETALLE
detail_file = "<h2><?php echo $title ?></h2>
<div class=\"well well-large well-transparent\">
<?php
 /* echo '<p>Categoria: '.$this->Categoria->traer_nombre($query->categoria_id).' </p>'; */
 "
 #campos
@campos_clean.each do |campo|
	confirm_file << " <p>#{campo.capitalize}: <?php echo $query->#{campo}; ?></p>\n"
end

#si hay imagen
if @imagenes == "1"
	detail_file << "if($query->filename){
	 echo '<p><img src=\"'.base_url('images-#{@plural}/'.$query->filename).'\" width=\"140\" /></p>';
	}"
end
detail_file << "
?>
<div class=\"btn-group\">
<a class=\"btn btn-small\" href=\"<?php echo base_url('control/#{@plural}/delete_comfirm/'.$query->id.''); ?>\">Eliminar</a>
<a class=\"btn btn-small\" href=\"<?php echo base_url('control/#{@plural}/editar/'.$query->id.''); ?>\">Editar</a>
</div>
</div>"

file_detail = File.new("../application/views/control/#{@plural}/detail.php", "w+")
if file_detail
   file_detail.syswrite(detail_file)
else
   puts "Unable to open file! (detail)"
end


#FORM EDIT
form_edit_file = ""
if @imagenes =="1"
form_edit_file <<"<script>
	function show_preview(input) {
	if (input.files && input.files[0]) {
	var reader = new FileReader();
	reader.onload = function (e) {
	$('#previewImg').html('<img src=\"'+e.target.result+'\" width=\"140\" />' );
	}
	reader.readAsDataURL(input.files[0]);
	}
}
</script>"
end

form_edit_file <<"<?php  
$attributes = array('class' => 'form-horizontal', 'id' => 'edit_#{@singular}');
echo form_open_multipart(base_url('control/#{@plural}/update/'),$attributes);

echo form_hidden('id', $query->id); 
?>
<legend><?php echo $title ?></legend>
<div class=\"well well-large well-transparent\">

 


<!-- Text input-->
<!--
<div class=\"control-group\">
<label class=\"control-label\">Categoria id</label>
	<div class=\"controls\">
	<select name=\"categoria_id\" id=\"categoria_id\">
		<?php 
		/* 
		$categorias = $this->categoria->get_records_menu();
		if($categorias){

			foreach ($categorias as $value) {
				if($query->categoria_id == $value->id){$sel= \"selected\";}else{$sel=\"\";}
				echo '<option value=\"'.$value->id.'\" '.$sel.'>'.$value->nombre.'</option>';
			}
		}
		*/
		?>
		</select>
		
		<?php echo form_error('categoria_id','<p class=\"error\">', '</p>'); ?>
	</div>
</div>
-->
"
@campos_clean.each do |campo|
	if campo != "filename"
		form_edit_file <<"
		<!-- Text input-->
		<div class=\"control-group\">
		<label class=\"control-label\">Ref</label>
		<div class=\"controls\">
		<input value=\"<?php echo $query->#{campo}; ?>\" type=\"text\" name=\"#{campo}\" />
		<?php echo form_error('#{campo}','<p class=\"error\">', '</p>'); ?>
		</div>
		</div>"
	end
end


if @imagenes == "1"
	form_edit_file << "
	<!-- Text input-->
<div class=\"control-group\">
	<label class=\"control-label\">Imagen</label>
	<div class=\"controls\">
	<div id=\"previewImg\">
	<?php if($query->filename){
	echo '<p><img src=\"'.base_url('images-#{@plural}/'.$query->filename).'\" width=\"140\" /></p>';
	} ?>

</div>
	<input value=\"<?php echo set_value('filename'); ?>\" type=\"file\" name=\"filename\" onchange=\"show_preview(this)\"/>
	<?php echo form_error('filename','<p class=\"error\">', '</p>'); ?>
	</div>
</div>
"
end

form_edit_file <<"

<div class=\"control-group\">
<label class=\"control-label\"></label>
	<div class=\"controls\">
		<button class=\"btn\" type=\"submit\">Actualizar</button>
	</div>
</div>

</fieldset>

<?php echo form_close(); ?>

</div>
"

file_edit = File.new("../application/views/control/#{@plural}/edit_#{@singular}.php", "w+")
if file_edit
   file_edit.syswrite(form_edit_file)
else
   puts "Unable to open file! (form_edit)"
end


#NEW 
form_new_file = ""
if @imagenes =="1"
form_new_file <<"<script>
	function show_preview(input) {
	if (input.files && input.files[0]) {
	var reader = new FileReader();
	reader.onload = function (e) {
	$('#previewImg').html('<img src=\"'+e.target.result+'\" width=\"140\" />' );
	}
	reader.readAsDataURL(input.files[0]);
	}
}
</script>"
end

form_new_file << "<?php  

$attributes = array('class' => 'form-horizontal', 'id' => 'new_#{@singular}');
echo form_open_multipart(base_url('control/#{@plural}/create/'),$attributes);

echo form_hidden('#{@singular}[id]');

?>
<legend><?php echo $title ?></legend>
<div class=\"well well-large well-transparent\">


<!-- Text input-->
<!--
<div class=\"control-group\">
<label class=\"control-label\">Categoria</label>
	<div class=\"controls\">
		
		<select name=\"categoria_id\" id=\"categoria_id\">
		<?php  
		/*
		$categorias = $this->Categoria->get_records_menu();
		if($categorias){

			foreach ($categorias as $value) {
				echo '<option value=\"'.$value->id.'\">'.$value->nombre.'</option>';
			}
		}
		*/
		?>
		</select>

		<?php echo form_error('categoria_id','<p class=\"error\">', '</p>'); ?>
	</div>
</div>
-->"

@campos_clean.each do |campo|
	if campo != "filename"
		form_new_file <<"
		<!-- Text input-->
		<div class=\"control-group\">
		<label class=\"control-label\">#{campo.capitalize}</label>
		<div class=\"controls\">
		<input value=\"<?php echo set_value('#{campo}'); ?>\" type=\"text\" name=\"#{campo}\" />
		<?php echo form_error('#{campo}','<p class=\"error\">', '</p>'); ?>
		</div>
		</div>"
	end
end

if @imagenes == "1"
	form_new_file << "
	<!-- Text input-->
<div class=\"control-group\">
	<label class=\"control-label\">Imagen</label>
	<div class=\"controls\">
	<div id=\"previewImg\"></div>
	<input value=\"<?php echo set_value('filename'); ?>\" type=\"file\" name=\"filename\" onchange=\"show_preview(this)\"/>
	<?php echo form_error('filename','<p class=\"error\">', '</p>'); ?>
	</div>
</div>
"
end

form_new_file << "

<div class=\"control-group\">
<label class=\"control-label\"></label>
	<div class=\"controls\">
		<button class=\"btn\" type=\"submit\">Crear</button>
	</div>
</div>



</fieldset>

<?php echo form_close(); ?>

</div>"

file_new = File.new("../application/views/control/#{@plural}/new_#{@singular}.php", "w+")
if file_new
   file_new.syswrite(form_new_file)
else
   puts "Unable to open file! (vista form_new)"
end

#MENU 
menu_file ="
<div class=\"well sidebar-nav\">
	<ul class=\"nav nav-list\">
		<li class=\"nav-header\">Opciones</li>
		<li><a href=\"<?php echo base_url('control/#{@plural}/');?>\">Ver #{@plural.capitalize}</a></li>
		<li><a href=\"<?php echo base_url('control/#{@plural}/form_new'); ?>\">Nuevo #{@singular.capitalize}</a></li>
	</ul>
</div><!--/.well -->
"
file_menu = File.new("../application/views/control/#{@plural}/menu_#{@singular}.php", "w+")
if file_menu
   file_menu.syswrite(menu_file)
else
   puts "Unable to open file! (vista menu)"
end