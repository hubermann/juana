controller_usuarios = "<?php 

class usuarios extends CI_Controller{


public function __construct(){

  parent::__construct();
  $this->load->model('usuario');
  $this->load->model('permiso');
  $this->load->model('rol');
  $this->load->helper('url');
  $this->load->library('session');

  //Si no hay session redirige a Login
  if(! $this->session->userdata('logged_in')){
    redirect('dashboard');
  }

}

public function index(){
  $this->permiso->verify_access( 'usuarios', 'view');
  //Pagination
  $per_page = 4;
  $page = $this->uri->segment(3);
  if(!$page){ $start =0; $page =1; }else{ $start = ($page -1 ) * $per_page; }
    $data['pagination_links'] = \"\";
    $total_pages = ceil($this->usuario->count_rows() / $per_page);

    if ($total_pages > 1){ 
      for ($i=1;$i<=$total_pages;$i++){ 
      if ($page == $i) 
        //si muestro el índice de la página actual, no coloco enlace 
        $data['pagination_links'] .=  '<li class=\"active\"><a>'.$i.'</a></li>'; 
      else 
        //si el índice no corresponde con la página mostrada actualmente, coloco el enlace para ir a esa pagina 
        $data['pagination_links']  .= '<li><a href=\"'.base_url().'control/usuarios/'.$i.'\" > '. $i .'</a></li>'; 
    } 
  }
  //End Pagination

  $data['title'] = 'usuarios';
  $data['menu'] = 'control/usuarios/menu_usuario';
  $data['content'] = 'control/usuarios/all';
  $data['query'] = $this->usuario->get_records($per_page,$start);
  $this->load->view('control/control_layout', $data);

}

//detail
public function detail(){
  $this->permiso->verify_access( 'usuarios', 'view');

  $data['title'] = 'usuario';
  $data['content'] = 'control/usuarios/detail';
  $data['menu'] = 'control/usuarios/menu_usuario';
  $data['query'] = $this->usuario->get_record($this->uri->segment(4));
  $this->load->view('control/control_layout', $data);
}


//new
public function form_new(){
  $this->permiso->verify_access( 'usuarios', 'create');
  $this->load->helper('form');
  $data['title'] = 'Nuevo usuario';
  $data['content'] = 'control/usuarios/new_usuario';
  $data['menu'] = 'control/usuarios/menu_usuario';
  $this->load->view('control/control_layout', $data);
}



public function logout(){
  $this->usuario->logout();
}
//create
public function create(){
  $this->permiso->verify_access( 'usuarios', 'create');
  $this->load->helper('form');
  $this->load->library('form_validation');
  $this->form_validation->set_rules('nombre', 'Nombre', 'required');
  $this->form_validation->set_rules('apellido', 'Apellido', 'required');
  $this->form_validation->set_rules('email', 'Email', 'required|is_unique[usuarios.email]');
  $this->form_validation->set_rules('password', 'Password', 'required');
  $this->form_validation->set_rules('role_id', 'Role_id', 'required');


  $this->form_validation->set_message('required','El campo %s es requerido.');
  $this->form_validation->set_message('is_unique', 'Ya existe otro usuario registrado con ese E-mail');

if ($this->form_validation->run() === FALSE){

    $this->load->helper('form');
    $data['title'] = 'Nuevo usuarios';
    $data['content'] = 'control/usuarios/new_usuario';
    $data['menu'] = 'control/usuarios/menu_usuario';
    $this->load->view('control/control_layout', $data);

  }else{
    /*
    $this->load->helper('url');
    $slug = url_title($this->input->post('titulo'), 'dash', TRUE);
    */
    $file  = $this->upload_file();
    if($_FILES['filename']['size'] > 0){
      if ( $file['status'] == 0 ){
        $this->session->set_flashdata('error', $file['msg']);
      }
    }else{
      $file['filename'] = '';
    }


    // set default time zone if not set at php.ini
    if (!date_default_timezone_get('date.timezone'))
    {
    date_default_timezone_set('America/Buenos_Aires');
    }
    $ahora = date(\"Y-m-d H:i:s\");


    //encrypto

    $salt = md5(uniqid(rand(), true));
    $hash = hash('sha512', $salt.$this->input->post('password'));

    $newusuario = array( 
      'nombre' => $this->input->post('nombre'), 
      'apellido' => $this->input->post('apellido'), 
      'email' => $this->input->post('email'), 
      'password' => $hash, 
      'salt' => $salt, 
      'role_id' => $this->input->post('role_id'), 
      'created_at' => $ahora, 
      'updated_at' => $ahora, 
      'filename' => \"\", 
    );
    #save
    $this->usuario->add_record($newusuario);
    $this->session->set_flashdata('success', 'usuario creado. <a href=\"usuarios/detail/'.$this->db->insert_id().'\">Ver</a>');
    redirect('control/usuarios', 'refresh');

  }



}

//edit
public function editar(){
  $this->permiso->verify_access( 'usuarios', 'edit');
  $this->load->helper('form');
  $data['title']= 'Editar usuario'; 
  $data['content'] = 'control/usuarios/edit_usuario';
  $data['menu'] = 'control/usuarios/menu_usuario';
  $data['query'] = $this->usuario->get_record($this->uri->segment(4));
  $this->load->view('control/control_layout', $data);
}

//update
public function update(){
  $this->permiso->verify_access( 'usuarios', 'edit');
  $this->load->helper('form');
  $this->load->library('form_validation'); 
  $this->form_validation->set_rules('nombre', 'Nombre', 'required');
  $this->form_validation->set_rules('apellido', 'Apellido', 'required');
  $this->form_validation->set_rules('email', 'Email', 'required');
  $this->form_validation->set_rules('password', 'Password', 'required');

  $this->form_validation->set_rules('role_id', 'Role_id', 'required');


  $this->form_validation->set_message('required','El campo %s es requerido.');

  if ($this->form_validation->run() === FALSE){
    $this->load->helper('form');

    $data['title'] = 'Nuevo usuario';
    $data['content'] = 'control/usuarios/edit_usuario';
    $data['menu'] = 'control/usuarios/menu_usuario';
    $data['query'] = $this->usuario->get_record($this->input->post('id'));
    $this->load->view('control/control_layout', $data);
  }else{
    if($_FILES['filename']['size'] > 0){
    
      $file  = $this->upload_file();
    
      if ( $file['status'] != 0 )
        {
        //guardo
        $usuario = $this->usuario->get_record($this->input->post('id'));
           $path = 'images-usuarios/'.$usuario->filename;
           if(is_link($path)){
            unlink($path);
           }
        
        
        $data = array('filename' => $file['filename']);
        $this->usuario->update_record($this->input->post('id'), $data);
        }
    
    
}   
    $id=  $this->input->post('id');

    // set default time zone if not set at php.ini
    if (!date_default_timezone_get('date.timezone'))
    {
    date_default_timezone_set('America/Buenos_Aires');
    }
    $ahora = date(\"Y-m-d H:i:s\");


    //encrypto

    $salt = md5(uniqid(rand(), true));
    $hash = hash('sha512', $salt.$this->input->post('password'));

    $editedusuario = array(  
      'nombre' => $this->input->post('nombre'),
      'apellido' => $this->input->post('apellido'),
      'email' => $this->input->post('email'),
      'password' => $hash,
      'salt' => $salt,
      'role_id' => $this->input->post('role_id'),
      'updated_at' => $ahora,
    );

    #save
    $this->session->set_flashdata('success', 'usuario Actualizado!');
    $this->usuario->update_record($id, $editedusuario);
    if($this->input->post('id')!=\"\"){
      redirect('control/usuarios', 'refresh');
    }else{
      redirect('control/usuarios', 'refresh');
    }



  }



}


public function soft_delete(){
  $permiso = $this->permiso->verify_access_ajax( 'usuarios', 'delete');
  if(!$permiso){
    $retorno = array('status' => 3);
    echo json_encode($retorno);
    exit;
  }
  // 0 Active
  // 1 Deleted
  // 2 Draft
  $id_usuario = $this->input->post('iditem');
  if($id_usuario > 0 && $id_usuario != \"\"){
    $editedusuario = array(  
    'status' => 1,
    );
    $this->usuario->update_record($id_usuario, $editedusuario);
    $retorno = array('status' => 1);
    echo json_encode($retorno);
  }else{
    $retorno = array('status' => 0);
    echo json_encode($retorno);
  }
}



public function upload_file(){
  $this->permiso->verify_access( 'usuarios', 'edit');
  //1 = OK - 0 = Failure
  $file = array('status' => '', 'filename' => '', 'msg' => '' );


  //check ext.
  $file_extensions_allowed = array('image/gif', 'image/png', 'image/jpeg', 'image/jpg');
  $exts_humano = array('gif', 'png', 'jpeg', 'jpg');
  $exts_humano = implode(', ',$exts_humano);
  $ext = $_FILES['filename']['type'];
  #$ext = strtolower($ext);
  if(!in_array($ext, $file_extensions_allowed)){
    $exts = implode(', ',$file_extensions_allowed);

    $file['msg'] .=\"<p>\".$_FILES['filename']['name'].\" <br />Puede subir archivos que tengan alguna de estas extenciones: \".$exts_humano.\"</p>\";

  }else{
    include(APPPATH.'libraries/class.upload.php');
    $yukle = new upload;
    $yukle->set_max_size(1900000);
    $yukle->set_directory('./images-usuarios');
    $yukle->set_tmp_name($_FILES['filename']['tmp_name']);
    $yukle->set_file_size($_FILES['filename']['size']);
    $yukle->set_file_type($_FILES['filename']['type']);
    $random = substr(md5(rand()),0,6);
    $name_whitout_whitespaces = str_replace(\" \",\"-\",$_FILES['filename']['name']);
    $imagname=''.$random.'_'.$name_whitout_whitespaces;
    #$thumbname='tn_'.$imagname;
    $yukle->set_file_name($imagname);


    $yukle->start_copy();


    if($yukle->is_ok()){
      #$yukle->resize(600,0);
      #$yukle->set_thumbnail_name('tn_'.$random.'_'.$name_whitout_whitespaces);
      #$yukle->create_thumbnail();
      #$yukle->set_thumbnail_size(180, 0);

      //UPLOAD ok
      $file['filename'] = $imagname;
      $file['status'] = 1;
    }
    else{
      $file['status'] = 0 ;
      $file['msg'] = 'Error al subir archivo';
    }

    //clean
    $yukle->set_tmp_name('');
    $yukle->set_file_size('');
    $yukle->set_file_type('');
    $imagname='';
  }//fin if(extencion)  


  return $file;
}


} //end class

?>"

file_controller_usuarios = File.new("../application/controllers/usuarios.php", "w+")
if file_controller_usuarios
   file_controller_usuarios.syswrite(controller_usuarios)
else
   puts "Unable to open file!"
end