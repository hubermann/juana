controller_permisos = "<?php 

class permisos extends CI_Controller{


public function __construct(){

parent::__construct();
$this->load->model('permiso');
$this->load->model('modulo');
$this->load->model('rol');
$this->load->helper('url');
$this->load->library('session');

//Si no hay session redirige a Login
if(! $this->session->userdata('logged_in')){
redirect('dashboard');
}



}

public function index(){
  
  $data['title'] = 'Permisos';
  $data['menu'] = 'control/permisos/menu_permiso';
  $data['content'] = 'control/permisos/all';
  $data['modulos'] = $this->modulo->get_records();
  $data['permisos'] = $this->rol->get_records();
  $this->load->view('control/control_layout', $data);

}

//detail
public function detail(){

$data['title'] = 'permiso';
$data['content'] = 'control/permisos/detail';
$data['menu'] = 'control/permisos/menu_permiso';
$data['query'] = $this->permiso->get_record($this->uri->segment(4));
$this->load->view('control/control_layout', $data);
}


//new
public function form_new(){
$this->load->helper('form');
$data['title'] = 'Nuevo permiso';
$data['content'] = 'control/permisos/new_permiso';
$data['menu'] = 'control/permisos/menu_permiso';
$this->load->view('control/control_layout', $data);
}

//create
public function create(){

  $this->load->helper('form');
  $this->load->library('form_validation');
  $this->form_validation->set_rules('role_id', 'Role_id', 'required');

  $this->form_validation->set_rules('modulo', 'Modulo', 'required');

  $this->form_validation->set_rules('url', 'Url', 'required');

  $this->form_validation->set_rules('permiso', 'Permiso', 'required');

  $this->form_validation->set_message('required','El campo %s es requerido.');

if ($this->form_validation->run() === FALSE){

    $this->load->helper('form');
    $data['title'] = 'Nuevo permisos';
    $data['content'] = 'control/permisos/new_permiso';
    $data['menu'] = 'control/permisos/menu_permiso';
    $this->load->view('control/control_layout', $data);

  }else{
    /*
    $this->load->helper('url');
    $slug = url_title($this->input->post('titulo'), 'dash', TRUE);
    */
    $newpermiso = array( 'role_id' => $this->input->post('role_id'), 
     'modulo' => $this->input->post('modulo'), 
     'url' => $this->input->post('url'), 
     'permiso' => $this->input->post('permiso'), 
    );
    #save
    $this->permiso->add_record($newpermiso);
    $this->session->set_flashdata('success', 'permiso creado. <a href=\"permisos/detail/'.$this->db->insert_id().'\">Ver</a>');
    redirect('control/permisos', 'refresh');

  }



}

//edit
public function editar(){
  $this->load->helper('form');
  $data['title']= 'Editar permiso'; 
  $data['content'] = 'control/permisos/edit_permiso';
  $data['menu'] = 'control/permisos/menu_permiso';
  $data['query'] = $this->permiso->get_record($this->uri->segment(4));
  $this->load->view('control/control_layout', $data);
}

//update
public function update(){
  $this->load->helper('form');
  $this->load->library('form_validation'); 
  $this->form_validation->set_rules('role_id', 'Role_id', 'required');

  $this->form_validation->set_rules('modulo', 'Modulo', 'required');

  $this->form_validation->set_rules('url', 'Url', 'required');

  $this->form_validation->set_rules('permiso', 'Permiso', 'required');


  $this->form_validation->set_message('required','El campo %s es requerido.');

  if ($this->form_validation->run() === FALSE){
    $this->load->helper('form');

    $data['title'] = 'Nuevo permiso';
    $data['content'] = 'control/permisos/edit_permiso';
    $data['menu'] = 'control/permisos/menu_permiso';
    $data['query'] = $this->permiso->get_record($this->input->post('id'));
    $this->load->view('control/control_layout', $data);
  }else{    
    $id=  $this->input->post('id');

    $editedpermiso = array(  
    'role_id' => $this->input->post('role_id'),

    'modulo' => $this->input->post('modulo'),

    'url' => $this->input->post('url'),

    'permiso' => $this->input->post('permiso'),
    );
    #save
    $this->session->set_flashdata('success', 'permiso Actualizado!');
    $this->permiso->update_record($id, $editedpermiso);
    if($this->input->post('id')!=\"\"){
      redirect('control/permisos', 'refresh');
    }else{
      redirect('control/permisos', 'refresh');
    }

  }



}

public function modif(){
  
  $role_id = 1;//$this->input->post('role_id');
  $modulo = 1;//$this->input->post('modulo');
  $action = 'view';//$this->input->post('action');
  $nuevo_permiso = 1;
  $this->permiso->modificar_permiso_rol($role_id, $modulo, $action, $nuevo_permiso);

}

public function update_permiso(){
  
  $role_id = $this->input->post('roleid');
  $modulo = $this->input->post('varmodulo');
  $action = $this->input->post('varaction');
  $nuevo_permiso = $this->input->post('varnuevopermiso');
  $status = $this->permiso->modificar_permiso_rol($role_id, $modulo, $action, $nuevo_permiso);

  
  if($status == 1){
    echo json_encode(array('status' => \"OK\"));
  }else{
    echo json_encode(array('status' => \"\"));
  }
  

}




public function soft_delete(){
  // 0 Active
  // 1 Deleted
  // 2 Draft
  $id_permiso = $this->input->post('idpermiso');
  if($id_permiso > 0 && $id_permiso != \"\"){
    $editedpermiso = array(  
    'status' => 1,
    );
    $this->permiso->update_record($id_permiso, $editedpermiso);
    $retorno = array('status' => 1);
    echo json_encode($retorno);
  }else{
    $retorno = array('status' => 0);
    echo json_encode($retorno);
  }
}



//delete comfirm    
public function delete_comfirm(){
  $this->load->helper('form');
  $data['content'] = 'control/permisos/comfirm_delete';
  $data['title'] = 'Eliminar permiso';
  $data['menu'] = 'control/permisos/menu_permiso';
  $data['query'] = $data['query'] = $this->permiso->get_record($this->uri->segment(4));
  $this->load->view('control/control_layout', $data);


}

//delete
public function delete(){

  $this->load->helper('form');
  $this->load->library('form_validation');

  $this->form_validation->set_rules('comfirm', 'comfirm', 'required');
  $this->form_validation->set_message('required','Por favor, confirme para eliminar.');


  if ($this->form_validation->run() === FALSE){
    #validation failed
    $this->load->helper('form');

    $data['content'] = 'control/permisos/comfirm_delete';
    $data['title'] = 'Eliminar permiso';
    $data['menu'] = 'control/permisos/menu_permiso';
    $data['query'] = $this->permiso->get_record($this->input->post('id'));
    $this->load->view('control/control_layout', $data);
  }else{
    #validation passed
    $this->session->set_flashdata('success', 'permiso eliminado!');

    $prod = $this->permiso->get_record($this->input->post('id'));
      $path = 'images-permisos/'.$prod->filename;
      if(is_link($path)){
        unlink($path);
      }
    

    $this->permiso->delete_record();
    redirect('control/permisos', 'refresh');
    

  }
}


} //end class

?>"

file_controller_permisos = File.new("../application/controllers/control/permisos.php", "w+")
if file_controller_permisos
   file_controller_permisos.syswrite(controller_permisos)
else
   puts "Unable to open file!"
end