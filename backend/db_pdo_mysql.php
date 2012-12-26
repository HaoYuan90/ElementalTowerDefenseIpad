<?php
/**
 * MySQL DB. All data is stored in data_pdo_mysql database
 * Create an empty MySQL database and set the dbname, username
 * and password below
 * 
 * This class will create the table with sample data
 * automatically on first `get` or `get($id)` request
 */
class DB_PDO_MySQL
{
    private $db;
    function __construct ()
    {
        try {
//update the dbname username and password to suit your server
            $this->db = new PDO(
            'mysql:host=localhost;dbname=test', 'root', 'qiaoliang007');
            $this->db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, 
            PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            throw new RestException(501, 'MySQL: ' . $e->getMessage());
        }
    }
    
    function get ($id, $installTableOnFailure = FALSE)
    {
        $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        try {
            $sql = 'SELECT * FROM maps WHERE user_id = ' . mysql_escape_string(
            $id);
            $result = $this->db->query($sql)
                ->fetch();
            $result['towers'] = json_decode($result['towers']);
            return $result;
        } catch (PDOException $e) {
            if (! $installTableOnFailure && $e->getCode() == '42S02') {
//SQLSTATE[42S02]: Base table or view not found: 1146 Table 'authors' doesn't exist
                $this->install();
                return $this->get($id, TRUE);
            }
            throw new RestException(501, 'MySQL: ' . $e->getMessage());
        }
    }
    
    function getAll ($installTableOnFailure = FALSE)
    {
        $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        try {
            $stmt = $this->db->query('SELECT * FROM maps');
            $result = $stmt->fetchAll();
            $size = count($result);
            for	($i = 0; $i < $size; $i++)
            	{
            		$result[$i]['towers'] = json_decode($result[$i]['towers']);
            	}
            return $result;
        } catch (PDOException $e) {
            if (! $installTableOnFailure && $e->getCode() == '42S02') {
//SQLSTATE[42S02]: Base table or view not found: 1146 Table 'authors' doesn't exist
                $this->install();
                return $this->getAll(TRUE);
            }
            throw new RestException(501, 'MySQL: ' . $e->getMessage());
        }
    }
    
    function insert ($rec)
    {
        $user_id = mysql_escape_string($rec['user_id']);
        $stage = mysql_escape_string($rec['stage']);
        $wave = mysql_escape_string($rec['wave']);
    	$towers =mysql_escape_string(json_encode ($rec['towers']));
        $sql = "INSERT INTO maps (user_id, stage,wave,towers) VALUES ('$user_id', $stage, $wave, '$towers')";
        if (! $this->db->query($sql))
        {
         //   the user_id already exist. update instead
         return $this->update($user_id, $rec);
         }
        return $this->get($user_id);
    }
    
    function update ($user_id, $rec)
    {
        $user_id = mysql_escape_string($user_id);
        $stage = mysql_escape_string($rec['stage']);
        $wave = mysql_escape_string($rec['wave']);
    	$towers = mysql_escape_string(json_encode($rec['towers']));
        $sql = "UPDATE maps SET user_id = '$user_id', stage =$stage, wave = $wave, towers = '$towers' WHERE user_id = 	$user_id";
        if (! $this->db->query($sql))
            return FALSE;
        return $this->get($user_id);
    }
    
    function delete ($id)
    {
        $r = $this->get($id);
        if (! $r || ! $this->db->query(
        'DELETE FROM maps WHERE user_id = ' . mysql_escape_string($id)))
            return FALSE;
        return $r;
    }
    
    private function id2int ($r)
    {
        if (is_array($r)) {
            if (isset($r['id'])) {
                $r['id'] = intval($r['id']);
            } else {
                foreach ($r as &$r0) {
                    $r0['id'] = intval($r0['id']);
                }
            }
        }
        return $r;
    }
    
    private function install ()
    {
        $this->db->exec(
        "CREATE TABLE maps (
            user_id VARCHAR(64) PRIMARY KEY ,
            stage TEXT NOT NULL ,
            wave TEXT NOT NULL,
            towers VARCHAR(1024)
            
            
        );");
        $this->db->exec(
        "INSERT INTO maps (user_id, stage,wave,towers) VALUES ('100000493784464', 1,24,'[[0,1,1],[1,3,9]]');
         INSERT INTO maps (user_id, stage,wave,towers) VALUES ('104256236034464', 2,0,'[[0,1,1]]');
        ");
    }
}