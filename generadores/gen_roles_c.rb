controller_roles = "<?php 

class roles extends CI_Controller{


public function __construct(){

  parent::__construct();
  $this->load->model('rol');
  $this->load->model('permiso');
  $this->load->helper('url');
  $this->load->library('session');

  //Si no hay session redirige a Login
  if(! $this->session->userdata('logged_in')){
  redirect('dashboard');
  }



}

public function index(){
  $this->permiso->verify_access( 'roles', 'view');
  //Pagination
  $per_page = 4;
  $page = $this->uri->segment(3);
  if(!$page){ $start =0; $page =1; }else{ $start = ($page -1 ) * $per_page; }
    $data['pagination_links'] = \"\";
    $total_pages = ceil($this->rol->count_rows() / $per_page);

    if ($total_pages > 1){ 
      for ($i=1;$i<=$total_pages;$i++){ 
      if ($page == $i) 
        //si muestro el índice de la página actual, no coloco enlace 
        $data['pagination_links'] .=  '<li class=\"active\"><a>'.$i.'</a></li>'; 
      else 
        //si el índice no corresponde con la página mostrada actualmente, coloco el enlace para ir a esa pagina 
        $data['pagination_links']  .= '<li><a href=\"'.base_url().'control/roles/'.$i.'\" > '. $i .'</a></li>'; 
    } 
  }
  //End Pagination

  $data['title'] = 'roles';
  $data['menu'] = 'control/roles/menu_rol';
  $data['content'] = 'control/roles/all';
  $data['query'] = $this->rol->get_records($per_page,$start);

  $this->load->view('control/control_layout', $data);

}

//detail
public function detail(){
  $this->permiso->verify_access( 'roles', 'view');

  $data['title'] = 'rol';
  $data['content'] = 'control/roles/detail';
  $data['menu'] = 'control/roles/menu_rol';
  $data['query'] = $this->rol->get_record($this->uri->segment(4));
  $this->load->view('control/control_layout', $data);
}


//new
public function form_new(){
  $this->permiso->verify_access( 'roles', 'create');
  $this->load->helper('form');
  $data['title'] = 'Nuevo rol';
  $data['content'] = 'control/roles/new_rol';
  $data['menu'] = 'control/roles/menu_rol';
  $this->load->view('control/control_layout', $data);
}

//create
public function create(){
  $this->permiso->verify_access( 'roles', 'create');
  $this->load->helper('form');
  $this->load->library('form_validation');
$this->form_validation->set_rules('nombre', 'Nombre', 'required');

  $this->form_validation->set_message('required','El campo %s es requerido.');

if ($this->form_validation->run() === FALSE){

    $this->load->helper('form');
    $data['title'] = 'Nuevo roles';
    $data['content'] = 'control/roles/new_rol';
    $data['menu'] = 'control/roles/menu_rol';
    $this->load->view('control/control_layout', $data);

  }else{
    /*
    $this->load->helper('url');
    $slug = url_title($this->input->post('titulo'), 'dash', TRUE);
    */$newrol = array( 'nombre' => $this->input->post('nombre'), 
);
    #save
    $this->rol->add_record($newrol);
    $this->session->set_flashdata('success', 'rol creado. <a href=\"roles/detail/'.$this->db->insert_id().'\">Ver</a>');
    redirect('control/roles', 'refresh');

  }



}

//edit
public function editar(){
  $this->permiso->verify_access( 'roles', 'edit');
  $this->load->helper('form');
  $data['title']= 'Editar rol'; 
  $data['content'] = 'control/roles/edit_rol';
  $data['menu'] = 'control/roles/menu_rol';
  $data['query'] = $this->rol->get_record($this->uri->segment(4));
  $this->load->view('control/control_layout', $data);
}

//update
public function update(){
  $this->permiso->verify_access( 'roles', 'edit');
  $this->load->helper('form');
  $this->load->library('form_validation'); 
$this->form_validation->set_rules('nombre', 'Nombre', 'required');


  $this->form_validation->set_message('required','El campo %s es requerido.');

  if ($this->form_validation->run() === FALSE){
    $this->load->helper('form');

    $data['title'] = 'Nuevo rol';
    $data['content'] = 'control/roles/edit_rol';
    $data['menu'] = 'control/roles/menu_rol';
    $data['query'] = $this->rol->get_record($this->input->post('id'));
    $this->load->view('control/control_layout', $data);
  }else{    
    $id=  $this->input->post('id');

    $editedrol = array(  
'nombre' => $this->input->post('nombre'),
);
    #save
    $this->session->set_flashdata('success', 'rol Actualizado!');
    $this->rol->update_record($id, $editedrol);
    if($this->input->post('id')!=\"\"){
      redirect('control/roles', 'refresh');
    }else{
      redirect('control/roles', 'refresh');
    }



  }



}


public function soft_delete(){
  $permiso = $this->permiso->verify_access_ajax( 'roles', 'delete');
  if(!$permiso){
    $retorno = array('status' => 3);
    echo json_encode($retorno);
    exit;
  }
  // 0 Active
  // 1 Deleted
  // 2 Draft
  $id_rol = $this->input->post('iditem');
  if($id_rol > 0 && $id_rol != \"\"){
    $editedrol = array(  
    'status' => 1,
    );
    $this->rol->update_record($id_rol, $editedrol);
    $retorno = array('status' => 1);
    echo json_encode($retorno);
  }else{
    $retorno = array('status' => 0);
    echo json_encode($retorno);
  }
}


} //end class

?>"

file_controller_roles = File.new("../application/controllers/control/roles.php", "w+")
if file_controller_roles
   file_controller_roles.syswrite(controller_roles)
else
   puts "Unable to open file!"
end