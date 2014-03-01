{include "header.tpl"}

<div id="loginbox">
	{if $e_msg}<h2 class="error">Wystąpił błąd: {$e_msg}</h2>{/if}
	<form action="login.php" method="post">
	Podaj login: <input type="text" name="login"/>
	Podaj hasło: <input type="password" name="password"/>
	<INPUT TYPE="submit" value="Zaloguj"/>
	</form>
</div>

{include "footer.tpl"}