<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;

use \App\Models\Page;
use \App\Models\User;

/* autoload */
require '../vendor/autoload.php';

/* session */
session_start();

/* settings */
require '/config.php';

/* app start */
$app = new \Slim\App(['settings' => $config]);
$container = $app->getContainer();

/* pdo db connect */
$container['db'] = function ($container) {

    $db = $container['settings']['db'];
    $pdo = new PDO("mysql:host=" . $db['host'] . ";dbname=" . $db['dbname'], 
	$db['user'], $db['pass']);
	
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
	
    return $pdo;

};

/* twig view */
$container['view'] = function ($container) {

    $view = new \Slim\Views\Twig('templates');

    // Instantiate and add Slim specific extension
    $router = $container->get('router');
    $uri = \Slim\Http\Uri::createFromEnvironment(new \Slim\Http\Environment($_SERVER));
    $view->addExtension(new \Slim\Views\TwigExtension($router, $uri));

    return $view;

};

/* Override the default Not Found Handler after App */
unset($app->getContainer()['notFoundHandler']);

$app->getContainer()['notFoundHandler'] = function ($container) {

    return function ($request, $response) use ($container) {
        //$response = new \Slim\Http\Response(404);
        return $container['view']->render($response, '404.twig', [])->withStatus(404);
    };

};

/* authorization: check user */
$container['auth'] = function ($container) {

    $isAuthorized = array();
    $isAuthorized["authorized"] = false;

    if( isset($_SESSION['authorization']) ){
        $checkUser = new User($container['db']);
        $isAuthorized = $checkUser->checkAuthorization($_SESSION['authorization']);
    }

	return $isAuthorized;

};

/* flash messages */
$container['flash'] = function () {

    return new \Slim\Flash\Messages();

};

/* csrf protection */
$container['csrf'] = function ($containerr) {

    return new \Slim\Csrf\Guard;

};

$app->add($container->get('csrf'));


/* "/" - main page */
$app->get('/', function (Request $request, Response $response) {

    $page = new Page($this->db);
    // $menu = $page->getPagesAll();
    $menu = $page->getPagesTree();

    return $this->view->render($response, 'main.twig', [
        'userName' => $this->auth["user"]["login"],
        'menu' => $menu,
    ]);

});

/* "/pages" - content page */
$app->get('/page[/{alias}]', function (Request $request, Response $response, array $args) {

    $alias = $args['alias'];

    $page = new Page($this->db);
    // $menu = $page->getPagesAll();
   
    $content =  $page->getPageByAlias($alias);
    $menu = $page->getPagesTree(0, $content["id"]);
    $pathway = $page->getPagePathwayById($content["id"], null);

    if( !empty($content) ){      
        return $this->view->render($response, 'page.twig', [
            'userName' => $this->auth["user"]["login"],
            'menu' => $menu,
            'page' => $content,
            'pathway' => array_reverse($pathway),
        ]);
    }else{
        throw new \Slim\Exception\NotFoundException($request, $response);
    }
  	
});

/* admin panel */

/* "/login" - login page */
$app->get('/login', function (Request $request, Response $response, array $args) {

    // CSRF token name and value
    $csrfProtection = array();
    $csrfProtection['nameKey'] = $this->csrf->getTokenNameKey();
    $csrfProtection['valueKey'] = $this->csrf->getTokenValueKey();
    $csrfProtection['name'] = $request->getAttribute($csrfProtection['nameKey']);
    $csrfProtection['value'] = $request->getAttribute($csrfProtection['valueKey']);
    
    if( $this->auth["authorized"] ){
        return $response->withRedirect('/admin/page', 301);	
    }else{
        return $this->view->render($response, 'login.twig', [ 
            'csrfProtection' => $csrfProtection,
            'page' => $pageOne
        ]);
    }

});

$app->post('/login', function (Request $request, Response $response, array $args) {

    $form = array();
    $form["login"] = $request->getParam("login");
    $form["password"] = $request->getParam("password");

    $user = new User($this->db);
    $checkPasswordAndGetNewHash = $user->checkPassword($form);

    if( $checkPasswordAndGetNewHash ){
        $_SESSION['authorization'] = $checkPasswordAndGetNewHash;

        return $response->withRedirect('/admin/page', 301);	
    }else{
        return $response->withRedirect('/login', 301);	
    }

});

/* "/logout" - logout page */
$app->get('/logout', function (Request $request, Response $response, array $args) {
    
    unset($_SESSION['authorization']);
	
    return $response->withRedirect('/', 301);	

});

/* "/admin" - admin page */
$app->get('/admin', function (Request $request, Response $response, array $args) {

    if( $this->auth["authorized"] ){
        return $response->withRedirect('/admin/page', 301);	
    }else{
        return $response->withRedirect('/login', 301);	
    }

});

/* admin, page, list */
$app->get('/admin/page', function (Request $request, Response $response, array $args) {

    if( !$this->auth["authorized"] ){
        return $response->withRedirect('/login', 301);	
    }

    $page = new Page($this->db);
    // $pageAll = $page->getPagesAll();
    $pageTree =  $page->getPagesTree();

    $alert = $this->flash->getFirstMessage('alert');

	return $this->view->render($response, '/admin/page.twig', [ 
        'userName' => $this->auth["user"]["login"],
        'alert' => $alert,
        // 'pages' => $pageAll,
        'tree' => $pageTree,
    ]);

});

/* admin, page, add */
$app->get('/admin/page/add', function (Request $request, Response $response, array $args) {
    
    // CSRF token name and value
    $csrfProtection = array();
    $csrfProtection['nameKey'] = $this->csrf->getTokenNameKey();
    $csrfProtection['valueKey'] = $this->csrf->getTokenValueKey();
    $csrfProtection['name'] = $request->getAttribute($csrfProtection['nameKey']);
    $csrfProtection['value'] = $request->getAttribute($csrfProtection['valueKey']); 

    if( !$this->auth["authorized"] ){
        return $response->withRedirect('/login', 301);	
    }

    $page = new Page($this->db);
    $pageTree =  $page->getPagesTree();

	return $this->view->render($response, '/admin/page-edit.twig', [ 
        'userName' => $this->auth["user"]["login"],
        'csrfProtection' => $csrfProtection,
        'tree' => $pageTree,
    ]);

});

/* admin, page, edit */
$app->get('/admin/page/edit[/{id}]', function (Request $request, Response $response, array $args) {

    // CSRF token name and value
    $csrfProtection = array();
    $csrfProtection['nameKey'] = $this->csrf->getTokenNameKey();
    $csrfProtection['valueKey'] = $this->csrf->getTokenValueKey();
    $csrfProtection['name'] = $request->getAttribute($csrfProtection['nameKey']);
    $csrfProtection['value'] = $request->getAttribute($csrfProtection['valueKey']);    

    if( !$this->auth["authorized"] ){
        return $response->withRedirect('/login', 301);	
    }

    $id = (int) $args['id'];

    $page = new Page($this->db);
    $pageOne = $page->getPageById($id);
    $pageTree =  $page->getPagesTree(0, $pageOne["parent"], $id);

	return $this->view->render($response, '/admin/page-edit.twig', [ 
        'userName' => $this->auth["user"]["login"],
        'csrfProtection' => $csrfProtection,
        'page' => $pageOne,
        'tree' => $pageTree,
    ]);

});

/* admin, page, save */
$app->post('/admin/page/save', function (Request $request, Response $response, array $args) {
    
    if( !$this->auth["authorized"] ){
        return $response->withRedirect('/login', 301);	
    }

    $page = new Page($this->db);

    $data = array();
    $data["id"] = (int) $request->getParam("page-id");
    $data["alias"] = $request->getParam("page-alias");
    $data["title"] = $request->getParam("page-title");
    $data["text"] = $request->getParam("page-text");
    $data["num"] = (int) $request->getParam("page-num");
    $data["parent"] = (int) $request->getParam("page-parent");

    if($data["id"]){
        //edit
        $page->editPage($data);
    }else{
        //add
        $page->addPage($data);
    }

    // Set flash message
    $this->flash->addMessage('alert', 'Changes saved');

    return $response->withRedirect('/admin/page', 301);	

});

/* admin, page, delete */
$app->get('/admin/page/delete[/{id}]', function (Request $request, Response $response, array $args) {

    if( !$this->auth["authorized"] ){
        return $response->withRedirect('/login', 301);	
    }

    $id = (int) $args['id'];

    $page = new Page($this->db);
    $page->deletePage($id);

    // Set flash message
    $this->flash->addMessage('alert', 'Page deleted');

    return $response->withRedirect('/admin/page', 301);	

});

/* admin, user, edit */
$app->get('/admin/user', function (Request $request, Response $response, array $args) {

    // CSRF token name and value
    $csrfProtection = array();
    $csrfProtection['nameKey'] = $this->csrf->getTokenNameKey();
    $csrfProtection['valueKey'] = $this->csrf->getTokenValueKey();
    $csrfProtection['name'] = $request->getAttribute($csrfProtection['nameKey']);
    $csrfProtection['value'] = $request->getAttribute($csrfProtection['valueKey']);    

    if( !$this->auth["authorized"] ){
        return $response->withRedirect('/login', 301);	
    }else{
        $userName = $this->auth["user"]["login"];
    }

    $alert = $this->flash->getFirstMessage('alert');

	return $this->view->render($response, '/admin/user.twig', [ 
        'alert' => $alert,
        'csrfProtection' => $csrfProtection,
        'userName' => $userName,
    ]);

});


/* admin, user, save */
$app->post('/admin/user/save', function (Request $request, Response $response, array $args) {
    
    if( !$this->auth["authorized"] ){
        return $response->withRedirect('/login', 301);	
    }

    $user = new User($this->db);

    $form = array();
    $form["login"] = $request->getParam("login");
    $form["password"] = $request->getParam("password");

    $newPass = $user->changePass($form, $this->auth["user"]['id']);

    // Set flash message
    $this->flash->addMessage('alert', 'new login: ' . $newPass['login'] . ', ' . 'new password: ' . $newPass['password']);

    return $response->withRedirect('/admin/user', 301);	

});

$app->run();

/*
For “Unlimited” optional parameters, you can do this:

$app->get('/hello[/{params:.*}]', function ($request, $response, $args) {
    $params = explode('/', $request->getAttribute('params'));
    // $params is an array of all the optional segments
});
*/

