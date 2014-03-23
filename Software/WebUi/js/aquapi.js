function confirmLink(theLink, message)
{
	var is_confirmed = confirm(message);

	if (is_confirmed) {
		theLink.href += '&is_sure=1';
	}
	return is_confirmed;
}

