<?php
namespace App\Controller;

use App\Controller\AppController;
use Cake\Network\Http\Client;

/**
 * Users Controller
 *
 * @property \App\Model\Table\UsersTable $Users
 */
class UsersController extends AppController
{
    public function login()
    {
        $http = new Client([
            'headers' => ['Content-Type' => 'application/json'],
            'host' => 'localhost',
            'port' => 3000,
        ]);
        if ($this->request->is('post')) {
            $json = [
                'identifier' => $this->request->data('email'),
                'secret' => $this->request->data('password')
            ];
            $request = $http->post('/authenticate', json_encode($json));
            $user = $request->json; // while developing ONLY
            $user['role'] = 'admin';
            if ($user) {
                $this->Auth->setUser($user);
                return $this->redirect($this->Auth->redirectUrl());
            }
            $this->Flash->error(__('Invalid username or password, try again'));
        }
    }

    public function logout()
    {
        return $this->redirect($this->Auth->logout());
    }

    public function index()
    {
        $request = $this->http->get('/users/list');

        $Users = $request->json;
//        debug($Users); die;
        $this->set('Users', $Users);
    }

    public function add()
    {
        if($this->request->is('post')) {

        }
    }
}
