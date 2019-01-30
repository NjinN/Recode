<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
</head>
<body>
	<h1><? keep "Hello" ?></h1>
	
	<h3>1大于2</h3>
	<? either 1 > 2 [?>
	<h3>这是正确的</h3>
	<? ] [ ?>
	<h3>这是错误的</h3>
	<? ] ?>
	
	<? loop 3 [ ?>
	<h3>循环测试</h3>
	<? ] ?>
</body>
</html>	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	