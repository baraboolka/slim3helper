<?php

namespace app\Models;
use PDO;

class User {
	
	public $pdo;
	
	function __construct (PDO $pdo){

		$this->pdo = $pdo;

	}
	
    public function checkPassword($form){

        $sql = "SELECT * FROM `users` WHERE login = :login AND password = :password";

		$query = $this->pdo->prepare($sql);	
		$query->bindParam(':login', $form["login"]);
		$query->bindParam(':password', md5($form["password"]));
		$query->execute();
		
		$userInBase = $query->fetch();

        if( $userInBase ){
            $result = $this->changeHash($userInBase["id"]);
        }else{
            $result = false;
        }

		return $result;

    } 

    public function changeHash($userId){

        $hash = hash('ripemd160', time());

        $sql = "UPDATE `users` SET `hash` = :hash WHERE `id` = :id";

		$query = $this->pdo->prepare($sql);
		$query->bindParam(':id', $userId);	
		$query->bindParam(':hash', $hash);		
		$query->execute();

        return $hash;

    }

    public function checkAuthorization($hash){

        $sql = "SELECT id, login FROM `users` WHERE hash = :hash";

		$query = $this->pdo->prepare($sql);
		$query->bindParam(':hash', $hash);
		$query->execute();

        $userInBase = $query->fetch();

        $result = array();
        
        if( $userInBase ){
            $result["user"] = $userInBase;
            $result["authorized"] = true;
        }else{
            $result["authorized"] = false;
        }

        return $result;

    }

    public function generateRandomPass(){

        $alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
        $pass = array();
        $alphaLength = strlen($alphabet) - 1;

        for ( $i = 0; $i < 5; $i++ ) {
            $letter = rand(0, $alphaLength);
            $password[] = $alphabet[$letter];
        }

        return implode($password);

    }

    public function changePass($form, $userId){
 
        //simple field validation
		if(empty($form["login"]) || $form["login"] == ""){
			$form["login"] = "admin";
		}

		if(empty($form["password"]) || $form["password"] == ""){
			$form["password"] = $this->generateRandomPass();
		}

        $newUserData = array();
        $newUserData["login"] = $form["login"];
        $newUserData["password"] = $form["password"];
       

        $sql = "UPDATE `users` SET `login` = :login, `password` = :password WHERE `id` = :id";

		$query = $this->pdo->prepare($sql);
        $query->bindParam(':id', $userId);	
		$query->bindParam(':login', $newUserData["login"]);	
		$query->bindParam(':password', md5($newUserData["password"]));		
		$query->execute();

		return $newUserData;

    }
}