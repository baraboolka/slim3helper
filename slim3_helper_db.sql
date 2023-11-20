-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 20 2023 г., 20:41
-- Версия сервера: 5.6.43
-- Версия PHP: 5.6.40

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `slim_helper`
--

-- --------------------------------------------------------

--
-- Структура таблицы `pages`
--

CREATE TABLE `pages` (
  `id` int(11) NOT NULL,
  `alias` text NOT NULL,
  `title` text NOT NULL,
  `text` text NOT NULL,
  `num` int(11) NOT NULL,
  `parent` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `pages`
--

INSERT INTO `pages` (`id`, `alias`, `title`, `text`, `num`, `parent`) VALUES
(1, 'slim-3-installation', 'Slim 3 installation', '<h3>Site</h3>\r\n\r\n<pre><code class=\"language-html\">\r\nhttps://www.slimframework.com/docs/v3/\r\n\r\n</code></pre>\r\n\r\n<h3>Source</h3>\r\n\r\n<pre><code class=\"language-html\">\r\nhttps://github.com/slimphp/Slim\r\n\r\n</code></pre>\r\n\r\n\r\n<h3>Console command for composer</h3>\r\n\r\n<pre><code class=\"language-html\">\r\ncomposer require slim/slim:3.*\r\n\r\n</code></pre>\r\n\r\n<h3>A simple example of index.php</h3>\r\n\r\n<pre><code class=\"language-php\">\r\nuse \\Psr\\Http\\Message\\ServerRequestInterface as Request;\r\nuse \\Psr\\Http\\Message\\ResponseInterface as Response;\r\n\r\n// autoload\r\nrequire \'../vendor/autoload.php\';\r\n\r\n// Create and configure Slim app\r\n$config = [\'settings\' => [\r\n    \'addContentLengthHeader\' => false,\r\n]];\r\n$app = new \\Slim\\App($config);\r\n\r\n// Define app routes\r\n$app->get(\'/hello/{name}\', function ($request, $response, $args) {\r\n    return $response->write(\"Hello \" . $args[\'name\']);\r\n});\r\n\r\n// Run app\r\n$app->run();\r\n\r\n</code></pre>\r\n\r\n<h3>.htaccess for public directory</h3>\r\n\r\n<pre><code class=\"language-css\">\r\nRewriteEngine on\r\nRewriteCond %{REQUEST_FILENAME} !-d\r\nRewriteCond %{REQUEST_FILENAME} !-f\r\nRewriteRule . index.php [L]\r\n\r\nRewriteCond %{HTTPS} =off \r\nRewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [QSA,L]\r\n\r\n</code></pre>\r\n\r\n<h3>Composer.json</h3>\r\n<pre><code class=\"language-php\">\r\n{\r\n    \"require\": {\r\n        \"slim/slim\": \"3.*\",\r\n        \"slim/twig-view\": \"^2.5\",\r\n        \"slim/flash\": \"^0.4.0\",\r\n        \"slim/csrf\": \"0.6.0\"\r\n    },\r\n    \"autoload\": {\r\n        \"psr-4\": {\r\n            \"App\\\\\": \"app/\"\r\n        }\r\n    }\r\n}\r\n\r\n</code></pre>\r\n\r\n<h3>After adding the \"autoload\" section (for custom classes) we need to upload the composer.json</h3>\r\n<pre><code class=\"language-php\">\r\ncomposer dump-autoload\r\n\r\n</code></pre>\r\n', 1, 0),
(3, 'twig-installation', 'Twig', '<h3>Site</h3>\r\n<pre><code class=\"language-html\">\r\nhttps://twig.symfony.com/\r\n\r\n</code></pre>\r\n\r\n<h3>Source</h3>\r\n<pre><code class=\"language-html\">\r\nhttps://github.com/slimphp/Twig-View\r\n\r\n</code></pre>\r\n\r\n<h3>Console command for composer</h3> \r\n<pre><code class=\"language-html\">\r\ncomposer require slim/twig-view\r\n\r\n</code></pre>\r\n\r\n<h3>Start twig container</h3>\r\n\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n/* app start */\r\n$app = new \\Slim\\App([\'settings\' => $config]);\r\n$container = $app->getContainer();\r\n\r\n/* twig view */\r\n$container[\'view\'] = function ($container) {\r\n\r\n    $view = new \\Slim\\Views\\Twig(\'templates\');\r\n\r\n    // Instantiate and add Slim specific extension\r\n    $router = $container->get(\'router\');\r\n    $uri = \\Slim\\Http\\Uri::createFromEnvironment(new \\Slim\\Http\\Environment($_SERVER));\r\n    $view->addExtension(new \\Slim\\Views\\TwigExtension($router, $uri));\r\n\r\n    return $view;\r\n\r\n};\r\n\r\n</code></pre>\r\n\r\n<h3>Using/render twig</h3>\r\n<pre><code class=\"language-php\">\r\n$app->get(\'/page[/{alias}]\', function (Request $request, Response $response, array $args) {\r\n	//...\r\n	return $this->view->render($response, \'page.twig\', [\r\n		//...\r\n	]);\r\n  	\r\n});\r\n\r\n</code></pre>\r\n\r\n<h3>Some syntax features with twig: ...including</h3>\r\n<pre><code class=\"language-html\">\r\n&lt;!-- index.twig -->\r\n{% include \'header.twig\' %}\r\n\r\n&lt;div id=\"main\">\r\n\r\n    {% include \'menu.twig\' %}\r\n\r\n    &lt;div id=\"content\">\r\n        {% block content %}\r\n            &lt;!-- content -->\r\n        {% endblock %}\r\n    &lt;/div>\r\n&lt;/div>\r\n\r\n{% include \'footer.twig\' %}\r\n\r\n</code></pre>\r\n\r\n<h3>...nesting</h3>\r\n<pre><code class=\"language-html\">\r\n&lt;!-- main.twig -->\r\n{% extends \"index.twig\" %}\r\n\r\n{% block content %}\r\n	&lt;h2>Main page&lt;/h2>\r\n	&lt;p>Hello. This is a simple CRUD-system&lt;/p>\r\n{% endblock %}\r\n\r\n</code></pre>\r\n\r\n<h3>...cyrcle \"for\" and variables</h3>\r\n<pre><code class=\"language-html\">\r\n&lt;ul>\r\n	{% for item in menu %}\r\n		&lt;li>\r\n			&lt;a href=\"/page/{{ item.alias }}\"> {{ item.title }} &lt;/a>\r\n		&lt;/li>\r\n	{% endfor %}\r\n&lt;/ul>\r\n\r\n</code></pre>\r\n\r\n<h3>...operator \"if-else\"</h3>\r\n<pre><code class=\"language-html\">\r\n&lt;div id=\"header-user\">\r\n	{% if userName %}\r\n		&lt;a href=\"/admin/page\">{{ userName }}&lt;/a> | &lt;a href=\"/logout\">out&lt;/a>\r\n	{% else %}\r\n		guest | &lt;a href=\"/login\">login&lt;/a>\r\n	{% endif %}     \r\n&lt;/div>	\r\n\r\n</code></pre>', 2, 0),
(4, 'config-and-using-db', 'Config and using db', '<h3>Add settings</h3>\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n/* default settings */\r\n$config[\'displayErrorDetails\'] = true;\r\n$config[\'addContentLengthHeader\'] = false;\r\n\r\n/* db settings */\r\n$config[\'db\'][\'host\']   = \'localhost\';\r\n$config[\'db\'][\'user\']   = \'username\';\r\n$config[\'db\'][\'pass\']   = \'password\';\r\n$config[\'db\'][\'dbname\'] = \'dbname\';\r\n\r\n</code></pre>\r\n\r\n<h3>Or move settings into config file</h3>\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n/* default settings */\r\n$config[\'displayErrorDetails\'] = true;\r\n$config[\'addContentLengthHeader\'] = false;\r\n\r\n/* db settings */\r\nrequire \"../config.php\";\r\n\r\n</code></pre>\r\n\r\n<h3>Pass settings to app and start db container</h3>\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n/* app start */\r\n$app = new \\Slim\\App([\'settings\' => $config]);\r\n$container = $app->getContainer();\r\n\r\n/* db connect */\r\n$container[\'db\'] = function ($container) {\r\n\r\n    $db = $container[\'settings\'][\'db\'];\r\n    $pdo = new PDO(\"mysql:host=\" . $db[\'host\'] . \";dbname=\" . $db[\'dbname\'], \r\n	$db[\'user\'], $db[\'pass\']);\r\n	\r\n    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);\r\n    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);\r\n	\r\n    return $pdo;\r\n\r\n};\r\n\r\n</code></pre>\r\n\r\n<h3>Using db</h3>\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n$app->get(\'/page[/{alias}]\', function (Request $request, Response $response, array $args) {\r\n\r\n    //...\r\n    $page = new Page($this->db);/* pass db container */\r\n    $menu = $page->getPagesAll();/* call the method */\r\n    //...\r\n  	\r\n});\r\n\r\n</code></pre>\r\n\r\n<pre><code class=\"language-php\">\r\n/* file Page.php with method getPagesAll() */\r\n\r\nnamespace app\\Models;\r\nuse PDO;\r\n\r\nclass Page {\r\n	\r\n	public $pdo;\r\n	\r\n	function __construct (PDO $pdo){\r\n\r\n		$this->pdo = $pdo;\r\n\r\n	}\r\n	\r\n	public function getPagesAll(){\r\n\r\n		$sql = \"SELECT * FROM `pages` ORDER BY num ASC\";\r\n\r\n		$query = $this->pdo->prepare($sql);\r\n		$query->execute();\r\n		\r\n		$result = $query->fetchAll();\r\n\r\n		return $result;\r\n\r\n	}\r\n	//...\r\n}\r\n\r\n</code></pre>\r\n\r\n\r\n<h3>Some sql-examples</h3>\r\n<pre><code class=\"language-php\">\r\n	//...\r\n	public function getPageByAlias($value){\r\n\r\n		$sql = \"SELECT * FROM `pages` WHERE alias = ? \";\r\n\r\n		$query = $this->pdo->prepare($sql);\r\n		$query->execute(array($value));\r\n		\r\n		$result = $query->fetch();\r\n\r\n		return $result;\r\n\r\n	}	\r\n	//...\r\n	public function checkPagesForDoubleAliases($alias, $id){\r\n	\r\n		$sql = \"SELECT * FROM `pages` WHERE alias = :alias AND id != :id\";\r\n\r\n		$query = $this->pdo->prepare($sql);	\r\n		$query->bindParam(\':alias\', $alias);\r\n		$query->bindParam(\':id\', $id);\r\n		$query->execute();\r\n		\r\n		$result = $query->fetchAll();\r\n\r\n		return $result;\r\n	}\r\n	//...\r\n	public function addPage($data){\r\n\r\n		//...\r\n		//sql\r\n		$sql = \"INSERT INTO `pages` \r\n		(`alias`, `title`, `text`, `num`) \r\n		VALUES (:alias, :title, :text, :num)\";\r\n\r\n		$query = $this->pdo->prepare($sql);\r\n		$query->bindParam(\':alias\', $data[\"alias\"]);\r\n		$query->bindParam(\':title\', $data[\"title\"]);\r\n		$query->bindParam(\':text\', $data[\"text\"]);\r\n		$query->bindParam(\':num\', $data[\"num\"]);\r\n		$query->execute();\r\n\r\n		$id = $this->pdo->lastInsertId();\r\n\r\n		return $id;\r\n\r\n	}\r\n	//...\r\n	public function editPage($data){\r\n\r\n		//...\r\n		//sql\r\n		$sql = \"UPDATE `pages` SET `alias` = :alias, `title` = :title, `text` = :text, `num` = :num WHERE `id` = :id\";\r\n\r\n		$query = $this->pdo->prepare($sql);\r\n		$query->bindParam(\':id\', $data[\"id\"]);	\r\n		$query->bindParam(\':alias\', $data[\"alias\"]);\r\n		$query->bindParam(\':title\', $data[\"title\"]);\r\n		$query->bindParam(\':text\', $data[\"text\"]);\r\n		$query->bindParam(\':num\', $data[\"num\"]);\r\n		$query->execute();\r\n\r\n		return $data[\"id\"];\r\n\r\n	}\r\n	//...\r\n		public function deletePage($id){\r\n\r\n		$sql = \"DELETE FROM `pages` WHERE `id` = ?\";\r\n		\r\n		$query = $this->pdo->prepare($sql);\r\n		$query->execute(array($id));\r\n\r\n		return $id;\r\n\r\n	}\r\n</code></pre>', 3, 0),
(29, 'csrf-protection-installation', 'CSRF protection', '<h3>Source</h3>\r\n<pre><code class=\"language-html\">\r\nhttps://github.com/slimphp/Slim-Csrf\r\n\r\n</code></pre>\r\n\r\n<h3>Console command for composer</h3> \r\n<pre><code class=\"language-html\">\r\ncomposer require slim/csrf \"0.6.0\"\r\n\r\n</code></pre>\r\n\r\n<h3>Add session start</h3> \r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n/* session */\r\nsession_start();\r\n\r\n</code></pre>\r\n\r\n<h3>Start csrf container</h3>\r\n\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n/* app start */\r\n$app = new \\Slim\\App([\'settings\' => $config]);\r\n$container = $app->getContainer();\r\n\r\n/* csrf protection */\r\n$container[\'csrf\'] = function ($containerr) {\r\n\r\n    return new \\Slim\\Csrf\\Guard;\r\n\r\n};\r\n\r\n$app->add($container->get(\'csrf\'));\r\n\r\n</code></pre>\r\n\r\n<h3>Using csrf</h3>\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n$app->get(\'/login\', function (Request $request, Response $response, array $args) {\r\n\r\n    // CSRF token name and value\r\n    $csrfProtection = array();\r\n    $csrfProtection[\'nameKey\'] = $this->csrf->getTokenNameKey();\r\n    $csrfProtection[\'valueKey\'] = $this->csrf->getTokenValueKey();\r\n    $csrfProtection[\'name\'] = $request->getAttribute($csrfProtection[\'nameKey\']);\r\n    $csrfProtection[\'value\'] = $request->getAttribute($csrfProtection[\'valueKey\']);\r\n    \r\n    if( $this->auth[\"authorized\"] ){\r\n        return $response->withRedirect(\'/admin/page\', 301);	\r\n    }else{\r\n        return $this->view->render($response, \'login.twig\', [ \r\n            \'csrfProtection\' => $csrfProtection,\r\n            \'page\' => $pageOne\r\n        ]);\r\n    }\r\n\r\n});\r\n\r\n</code></pre>\r\n\r\n<pre><code class=\"language-html\">\r\n&lt;!-- login.twig -->\r\n&lt;!-- form -->\r\n&lt;form action=\"/login\" method=\"post\" class=\"login-form\">\r\n	&lt;label for=\"login\">login&lt;/label>\r\n	&lt;input type=\"text\" name=\"login\" autocomplete=\"off\">\r\n\r\n	&lt;label for=\"password\">password&lt;/label>\r\n	&lt;input type=\"password\" name=\"password\" autocomplete=\"off\">\r\n\r\n	&lt;input type=\"hidden\" name=\"{{ csrfProtection.nameKey }}\" value=\"{{ csrfProtection.name }}\">\r\n	&lt;input type=\"hidden\" name=\"{{ csrfProtection.valueKey }}\" value=\"{{ csrfProtection.value }}\">\r\n\r\n	&lt;input type=\"submit\" value=\"login\">\r\n&lt;/form>\r\n\r\n\r\n</code></pre>', 4, 0),
(30, 'flash-installation', 'Flash messages', '<h3>Source</h3>\r\n<pre><code class=\"language-html\">\r\nhttps://github.com/slimphp/Slim-Flash\r\n\r\n</code></pre>\r\n\r\n<h3>Console command for composer</h3> \r\n<pre><code class=\"language-html\">\r\ncomposer require slim/flash\r\n\r\n</code></pre>\r\n\r\n<h3>Start flash container</h3>\r\n\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n/* session */\r\nsession_start();\r\n\r\n/* app start */\r\n$app = new \\Slim\\App([\'settings\' => $config]);\r\n$container = $app->getContainer();\r\n\r\n/* flash messages */\r\n$container[\'flash\'] = function () {\r\n\r\n    return new \\Slim\\Flash\\Messages();\r\n\r\n};\r\n\r\n</code></pre>\r\n\r\n\r\n<h3>Simple use</h3>\r\n<pre><code class=\"language-php\">\r\n/* index.php */\r\n\r\n$app->get(\'/foo\', function ($req, $res, $args) {\r\n    // Set flash message for next request\r\n    $this->flash->addMessage(\'Test\', \'This is a message\');\r\n\r\n    // Redirect\r\n    return $res->withStatus(302)->withHeader(\'Location\', \'/bar\');\r\n});\r\n\r\n$app->get(\'/bar\', function ($req, $res, $args) {\r\n    // Get flash messages from previous request\r\n    $messages = $this->flash->getMessages();\r\n    print_r($messages);\r\n\r\n    // Get the first message from a specific key\r\n    $test = $this->flash->getFirstMessage(\'Test\');\r\n    print_r($test);\r\n});\r\n\r\n$app->run();\r\n\r\n</code></pre>', 5, 0),
(33, 'strange-things', 'Strange things', '<h3>Strange thing 1:</h3>\r\nIf we want to output prism.js constructions (like &lt;pre>&lt;code...>) with a twig variable, we need to use the \"raw\" parameter\r\n\r\n<pre><code class=\"language-php\">\r\n{{ page.text | raw }}\r\n\r\n</code></pre>\r\n\r\n<h3>Strange thing 2:</h3>\r\nIf we want to show html-tags in prism.js constructions, we need to change every \"<\" symbol with \"& lt;\"\r\n\r\n<pre><code class=\"language-html\">\r\n\"<\" <=> \"& lt;\"\r\n\r\n</code></pre>\r\n', 6, 0),
(34, 'slim-3', 'Slim 3', '<h3>Resources and references</h3>\r\n<ul>\r\n	<li>Slim Framework (php | base, v:3.*): <a href=\"https://github.com/slimphp/Slim\" target=\"_blank\">https://github.com/slimphp/Slim</a></li>\r\n</ul>\r\n\r\n<h3>Addons</h3>\r\n<ul>	\r\n	<li>Slim Framework Twig View (php | addon, v:^2.5): <a href=\"https://github.com/slimphp/Twig-View\" target=\"_blank\">https://github.com/slimphp/Twig-View</a></li>\r\n	<li>Slim Framework Flash Messages (php | addon, v:^0.4.0): <a href=\"https://github.com/slimphp/Slim-Flash\" target=\"_blank\">https://github.com/slimphp/Slim-Flash</a></li>\r\n	<li>Slim Framework CSRF Protection (php | addon, v:0.6.0): <a href=\"https://github.com/slimphp/Slim-Csrf\" target=\"_blank\">https://github.com/slimphp/Slim-Csrf</a></li>\r\n	<li>Prism.js (js | syntax highlighter): <a href=\"https://prismjs.com/\" target=\"_blank\">https://prismjs.com</a></li>\r\n</ul>\r\n\r\n<h3>System requirements</h3>\r\n<ul>\r\n	<li>Web server with URL rewriting</li>\r\n	<li>PHP 5.5 or newer</li>\r\n	<li>Mysql 5.6 or newer</li>\r\n	<li title=\"yes\">Personal сomputer</li>\r\n</ul>', 0, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `login` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `login`, `password`, `hash`) VALUES
(1, 'admin', '5f4dcc3b5aa765d61d8327deb882cf99', 'd11168ef576985fba02a1aeb2ad28c902c464461');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `pages`
--
ALTER TABLE `pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
