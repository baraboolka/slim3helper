<?php

namespace app\Models;
use PDO;

class Page {
	
	public $pdo;
	
	function __construct (PDO $pdo){

		$this->pdo = $pdo;

	}
	
	public function getPagesAll(){
		/* change maybe */
		$sql = "SELECT * FROM `pages` ORDER BY num ASC";

		$query = $this->pdo->prepare($sql);
		$query->execute();
		
		$result = $query->fetchAll();

		return $result;

	}

	public function getPagesTree($parent = 0, $selected = -1, $exclude = -1, $level = 0){

		$sql = "SELECT id, title, alias, parent FROM `pages` WHERE parent = :parent AND id != :exclude ORDER BY num ASC";

		$query = $this->pdo->prepare($sql);	
		$query->bindParam(':parent', $parent);
		$query->bindParam(':exclude', $exclude);
		$query->execute();
		
		$result = $query->fetchAll();

		$level++;

		foreach($result as $key => $value){
			$result[$key]["sub"] = $this->getPagesTree($value["id"], $selected, $exclude, $level);
			$result[$key]["level"] = $level;

			if($value["id"] == $selected){
				$result[$key]["selected"] = "selected";
			}else{
				$result[$key]["selected"] = "";
			}
		}

		return $result;
	}

	public function formalizeAlias($alias){
		
		$alias = trim($alias);
		$alias = function_exists('mb_strtolower') ? mb_strtolower($alias) : strtolower($alias);

		$special = array(
			'"', 
			'\'', 
			';', 
			',', 
			':', 
			'/', 
			'\\', 
			'=', 
			')', 
			'(', 
			'%', 
			'*', 
			'.',
			'?',
			' '
		); 
		
		$alias = str_replace($special, "-", $alias);

		return $alias;

	}

	public function changeCyrillicAlias($alias){

		$cyrillicToLatin = array(
			'a'=>'a',
			'б'=>'b',
			'в'=>'v',
			'г'=>'g',
			'д'=>'d',
			'е'=>'e',
			'ё'=>'e',
			'ж'=>'j',
			'з'=>'z',
			'и'=>'i',
			'й'=>'y',
			'к'=>'k',
			'л'=>'l',
			'м'=>'m',
			'н'=>'n',
			'o'=>'o',
			'п'=>'p',
			'р'=>'r',
			'с'=>'s',
			'т'=>'t',
			'у'=>'u',
			'ф'=>'f',
			'х'=>'h',
			'ц'=>'c',
			'ч'=>'ch',
			'ш'=>'sh',
			'щ'=>'shch',
			'ы'=>'y',
			'э'=>'e',
			'ю'=>'yu',
			'я'=>'ya',
			'ъ'=>'',
			'ь'=>''
		);

		$alias = strtr($alias, $cyrillicToLatin);

		return $alias;
		
	}	

	public function getPageById($value){

		$sql = "SELECT * FROM `pages` WHERE id = ? ";

		$query = $this->pdo->prepare($sql);
		$query->execute(array($value));
		
		$result = $query->fetch();

		return $result;

	}

	public function getPageByAlias($value){

		$sql = "SELECT * FROM `pages` WHERE alias = ? ";

		$query = $this->pdo->prepare($sql);
		$query->execute(array($value));
		
		$result = $query->fetch();

		return $result;

	}		

	public function checkPagesForDoubleAliases($alias, $id){
		$sql = "SELECT * FROM `pages` WHERE alias = :alias AND id != :id";

		$query = $this->pdo->prepare($sql);	
		$query->bindParam(':alias', $alias);
		$query->bindParam(':id', $id);
		$query->execute();
		
		$result = $query->fetchAll();

		return $result;
	}

	public function getPagePathwayById($id, $pathway){
		
		$sql = "SELECT id,title,alias,parent FROM `pages` WHERE id = :id";

		$query = $this->pdo->prepare($sql);	
		$query->bindParam(':id', $id);
		$query->execute();
		
		$result = $query->fetch();

		if($result){	
			$pathway[] = $result;
			
			return $this->getPagePathwayById($result["parent"], $pathway);	

		}else{

			return $pathway;
		}
	}

	public function addPage($data){

		//simple field validation
		if(empty($data["title"]) || $data["title"] == ""){
			$data["title"] = "new-page";
		}

		if(empty($data["alias"] ) || $data["alias"] == ""){
			$data["alias"] = "new-alias";
		}
		
		$data["alias"] = $this->formalizeAlias($data["alias"]);
		$data["alias"] = $this->changeCyrillicAlias($data["alias"]);

		$checkForDoubleAlias = $this->getPageByAlias($data["alias"]);

		if(!empty($checkForDoubleAlias)){
			$data["alias"] = $data["alias"] . "-" . time();
		}

		//sql
		$sql = "INSERT INTO `pages` 
		(`alias`, `title`, `text`, `num`, `parent`) 
		VALUES (:alias, :title, :text, :num, :parent)";

		$query = $this->pdo->prepare($sql);
		$query->bindParam(':alias', $data["alias"]);
		$query->bindParam(':title', $data["title"]);
		$query->bindParam(':text', $data["text"]);
		$query->bindParam(':num', $data["num"]);
		$query->bindParam(':parent', $data["parent"]);
		$query->execute();

		$id = $this->pdo->lastInsertId();

		return $id;

	}

	public function editPage($data){

		//simple field validation
		if(empty($data["title"]) || $data["title"] == ""){
			$data["title"] = "new-page";
		}

		if(empty($data["alias"]) || $data["alias"] == ""){
			$data["alias"] = "new-alias";
		}

		$data["alias"] = $this->formalizeAlias($data["alias"]);
		$data["alias"] = $this->changeCyrillicAlias($data["alias"]);

		$checkForDoubleAlias = $this->checkPagesForDoubleAliases($data["alias"], $data["id"]);
		
		if(!empty($checkForDoubleAlias)){
			$data["alias"] = $data["alias"] . "-" . time();
		}

		//sql
		$sql = "UPDATE `pages` SET `alias` = :alias, `title` = :title, `text` = :text, `num` = :num, `parent` = :parent WHERE `id` = :id";

		$query = $this->pdo->prepare($sql);
		$query->bindParam(':id', $data["id"]);	
		$query->bindParam(':alias', $data["alias"]);
		$query->bindParam(':title', $data["title"]);
		$query->bindParam(':text', $data["text"]);
		$query->bindParam(':num', $data["num"]);
		$query->bindParam(':parent', $data["parent"]);
		$query->execute();

		return $data["id"];

	}	

	public function deletePage($id){

		$sql = "DELETE FROM `pages` WHERE `id` = ?";
		
		$query = $this->pdo->prepare($sql);
		$query->execute(array($id));

		return $id;

	}
}