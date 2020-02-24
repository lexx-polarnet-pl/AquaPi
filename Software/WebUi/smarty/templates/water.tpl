{include "header.tpl"}
<script>
function confirmLink(theLink, message)
{
	var is_confirmed = confirm(message);

	if (is_confirmed) {
		theLink.href += '&is_sure=1';
	}
	return is_confirmed;
}

</script>
{include file='water_popup_box.tpl' id="ph-info" title="pH wody" 
	body= "Wartość pH jest miarą odczynu wody będącego jednym z najważniejszych wskaźników określających możliwości i warunki życia w wodzie. W akwarium słodkowodnym uzależniona jest głównie od zawartości węglanów, wodorowęglanów i dwutlenku węgla, a także od obecności innych substancji wykazujących właściwości kwasowo-zasadowe, takich jak np. substancje humusowe i garbniki. Należy wziąć pod uwagę, że parametr ten może ulegać dobowym wahaniom w związku z takimi procesami życiowymi organizmów jak asymilacja CO<sub>2</sub> i oddychanie."}
{include file='water_popup_box.tpl' id="ph-l2" title="pH wody jest zbyt niskie" 
	body= "Niska wartość pH może być spowodowana zbyt dużym dozowaniem CO2, zbyt niską twardością węglanową KH lub zastosowaniem zbyt dużej ilości preparatów obniżających pH."}
{include file='water_popup_box.tpl' id="ph-l1" title="Odczyn wody w akwarium może być zbyt niski dla roślin wodnych" 
	body= "Niska wartość pH może być spowodowana zbyt dużym dozowaniem CO2, zbyt niską twardością węglanową KH lub zastosowaniem zbyt dużej ilości preparatów obniżających pH."}
{include file='water_popup_box.tpl' id="ph-h1" title="pH wody może być zbyt wysokie dla roślin wodnych" 
	body= "Zbyt wysokie pH może wynikać z zastosowania wody o niewłaściwych parametrach albo z powodu intensywnej asymilacji CO2 przez rośliny. Należy się też upewnić, że wzrost pH nie jest spowodowany przez podłoże lub elementy wystroju zbiornika (np. kamienie wapienne)."}
{include file='water_popup_box.tpl' id="ph-h2" title="pH wody jest zbyt wysokie" 
	body= "Zbyt wysokie pH może wynikać z zastosowania wody o niewłaściwych parametrach albo z powodu intensywnej asymilacji CO2 przez rośliny. Należy się też upewnić, że wzrost pH nie jest spowodowany przez podłoże lub elementy wystroju zbiornika (np. kamienie wapienne)."}

{include file='water_popup_box.tpl' id="gh-info" title="Twardość ogólna GH" 
	body= "Wartość GH jest miarą stężenia kationów dwuwartościowych w wodzie. W przypadku akwarium i wód naturalnych są to zwykle kationy wapnia i magnezu. Należy mieć na uwadze, że poza ich sumarycznym stężeniem istotnym jest (szczególnie dla bardziej wymagających roślin) ich wzajemny stosunek."}
{include file='water_popup_box.tpl' id="gh-l2" title="Twardość ogólna GH wody jest zbyt niska" 
	body= "Zbyt niska twardość ogólna GH może wynikać z niedostatecznego zmineralizowania wody użytej w akwarium."}
{include file='water_popup_box.tpl' id="gh-l1" title="Twardość ogólna GH wody może być zbyt niska dla większości roślin wodnych." 
	body= "Zbyt niska twardość ogólna GH może wynikać z niedostatecznego zmineralizowania wody użytej w akwarium."}
{include file='water_popup_box.tpl' id="gh-h1" title="Twardość wody może być zbyt wysoka dla większości roślin wodnych." 
	body= "Wysoka wartość tego parametru może wynikać z użycia zbyt twardej wody w akwarium, a także z zastosowania niewłaściwego mineralizatora lub z jego przedawkowania."}
{include file='water_popup_box.tpl' id="gh-h2" title="Twardość ogólna GH wody jest zbyt wysoka" 
	body= "Wysoka wartość tego parametru może wynikać z użycia zbyt twardej wody w akwarium, a także z zastosowania niewłaściwego mineralizatora lub z jego przedawkowania."}

{include file='water_popup_box.tpl' id="kh-info" title="Twardość węglanowa KH" 
	body= "Twardość węglanowa KH (zasadowość) jest miarą pojemności kwasowej wody i zdolności do stabilizowania pH korzystnego dla organizmów w akwarium. Zasadowość powodowana jest głównie obecnością wodorowęglanów wapnia i magnezu, a w niektórych wodach także występowaniem węglanów i wodorowęglanów sodu i potasu. W akwarium roślinnym w pewnych warunkach może nastąpić spadek wartości KH (deficyt CO<sub>2</sub>, obniżenie KH przez podłoże), dlatego należy regularnie dokonywać pomiarów tego parametru. "}	
{include file='water_popup_box.tpl' id="kh-l2" title="Twardość węglanowa KH wody jest zbyt niska" 
	body= "Zbyt niska wartość KH może wynikać z niedostatecznego zmineralizowania wody użytej w akwarium. Obniżanie wartości tego parametru mogą również powodować niektóre podłoża dla roślin zwłaszcza na początku ich użytkowania."}
{include file='water_popup_box.tpl' id="kh-l1" title="Twardość węglanowa KH wody może być zbyt niska dla roślin wodnych" 
	body= "Zbyt niska wartość KH może wynikać z niedostatecznego zmineralizowania wody użytej w akwarium. Obniżanie wartości tego parametru mogą również powodować niektóre podłoża dla roślin zwłaszcza na początku ich użytkowania."}
{include file='water_popup_box.tpl' id="kh-h1" title="Twardość węglanowa wody KH może być zbyt wysoka dla roślin wodnych." 
	body= "Zbyt wysoka twardość węglanowa KH może być spowodowana użyciem w akwarium twardej wody, a także występowaniem podłoża lub elementów dekoracji uwalniających węglany."}
{include file='water_popup_box.tpl' id="kh-h2" title="Twardość KH wody jest zbyt wysoka" 
	body= "Zbyt wysoka twardość węglanowa KH może być spowodowana użyciem w akwarium twardej wody, a także występowaniem podłoża lub elementów dekoracji uwalniających węglany."}

{include file='water_popup_box.tpl' id="no2-info" title="Azotyny NO<sub>2</sub>" 
	body= "Azotyny są toksyczne dla ryb i w wyższych stężeniach mogą prowadzić do śmierci. Dlatego parametry wody w akwarium powinny być regularnie sprawdzane i w razie potrzeby korygowane. Akwarysta powinien podjąć działania już przy stężeniu azotynów na poziomie 0,5 mg/l, ponieważ już w stężeniu 1 mg/l są one szkodliwe dla mieszkańców akwarium."}	
{include file='water_popup_box.tpl' id="no2-h" title="Zbyt dużo azotynów NO<sub>2</sub>" 
	body= "Nadmiar związków azotu powstaje wskutek przerybienia, nagromadzenia się nadmiaru mułu, odchodów ryb oraz gnijących resztek roślin i jedzenia. Brak regularnych podmian wody w akwarium oraz źle działająca filtracja również wpływają na zwiększenie stężenia związków azotu w wodzie."}

{include file='water_popup_box.tpl' id="no3-info" title="Azotany NO<sub>2</sub>" 
	body= "Zawartość azotanów w granicach 5-40 mg/l jest pożądana dla prawidłowego rozwoju roślin. Związki te są końcowym produktem tzw. azotowej przemiany odpadowych białek. W akwariach z rybami stężenie azotanów jest na ogół wystarczające i suplementacja nawozami zawierającymi azot nie jest potrzebna. Z drugiej strony nadmiar azotanów może być przyczyną gwałtownego wzrostu glonów i staje się szkodliwy dla bezkręgowców i wrażliwych ryb, wynika stąd potrzeba systematycznej kontroli ich zawartości."}	
{include file='water_popup_box.tpl' id="no3-l2" title="Zbyt mało azotanów" 
	body= "Utrzymywanie stężenia azotanów na niskim poziomie w dłuższym czasie może spowodować żółknięcie roślin i zahamowanie ich wzrostu."}
{include file='water_popup_box.tpl' id="no3-l1" title="Ilość azotanów w wodzie może być niewystarczająca dla roślin wodnych" 
	body= "Utrzymywanie stężenia azotanów na niskim poziomie w dłuższym czasie może spowodować żółknięcie roślin i zahamowanie ich wzrostu."}
{include file='water_popup_box.tpl' id="no3-h1" title="Ilość azotanów przewyższa bezpieczny poziom" 
	body= "Utrzymanie stężenia azotanów na zbyt wysokim poziomie może spowodować problemy z glonami. Wzrost stężenia azotanów jest zjawiskiem naturalnym, jednak jeśli następuje zbyt szybko może to świadczyć o przekarmianiu ryb lub o niewłaściwym nawożeniu."}
{include file='water_popup_box.tpl' id="no3-h2" title="Zbyt dużo azotanów" 
	body= "Utrzymanie stężenia azotanów na zbyt wysokim poziomie może spowodować problemy z glonami. Wzrost stężenia azotanów jest zjawiskiem naturalnym, jednak jeśli następuje zbyt szybko może to świadczyć o przekarmianiu ryb lub o niewłaściwym nawożeniu."}

{include file='water_popup_box.tpl' id="cl2-info" title="Chlor CL<sub>2</sub>" 
	body= "Chlor powoduje spalanie błony śluzowej ryb. Jest on często obecny w wodzie kranowej, dlatego przy zakładaniu nowego akwarium nie wolno od razu wpuszczać ryb do dopiero co nalanej wody. Akwarium z wodą powinno odstać kilka dni aby nadmiar chloru mógł się uwolnić. W wypadku zbyt dużego stężenia chloru trzeba również intensywniej napowietrzać wodę. Jego poziom można zbadać odpowiednim testem na obecność chloru."}	
{include file='water_popup_box.tpl' id="cl2-h" title="Zbyt dużo chloru CL<sub>2</sub>" 
	body= "Chlor w stężeniu od 0,1mg/l jest szkodliwy dla narybku i ikry, zaczyna szkodzić również dorosłym osobnikom"}
	
        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<section class="card">
							<div class="card-header">
								<div class="col-md-6">
									<strong class="card-title" v-if="headerText">Ostatnie pomiary wody</strong>
								</div>
								<div class="col-md-6 text-right">
									<a href="?action=addnew" class="btn btn-success btn-sm">
										<i class="fa fa-pencil-square-o"></i>&nbsp;Dodaj nowy pomiar
									</a>								
								</div> 							
							</div>							
							<div class="card-body card-block">
								<table id="bootstrap-data-table-export" class="table">
									<thead>
										<tr>
											<th>Data</th>
											<th>pH <i class="fa fa-question-circle text-info" data-toggle="modal" data-target="#ph-info"></i></th>
											<th>GH <i class="fa fa-question-circle text-info" data-toggle="modal" data-target="#gh-info"></i><br/>(dH)</th>
											<th>KH <i class="fa fa-question-circle text-info" data-toggle="modal" data-target="#kh-info"></i><br/>(dH)</th>
											<th>NO<sub>2</sub> <i class="fa fa-question-circle text-info" data-toggle="modal" data-target="#no2-info"></i><br/>(mg/l)</th>
											<th>NO<sub>3</sub> <i class="fa fa-question-circle text-info" data-toggle="modal" data-target="#no3-info"></i><br/>(mg/l)</th>
											<th>CL<sub>2</sub> <i class="fa fa-question-circle text-info" data-toggle="modal" data-target="#cl2-info"></i><br/>(mg/l)</th>
											<th>Komentarz</th>
											<th>&nbsp;</th>											
										</tr>
									</thead>
									<tbody>							
								{foreach from=$water item="measure"}							
										<tr>
											<td>{$measure.water_date|date_format:"%d-%m-%Y"}</td>
											<td>{if $measure.water_ph != null}
													{$measure.water_ph} 
													{if $measure.water_ph < 5.9}
														<i class="fa fa-arrow-circle-up text-danger" data-toggle="modal" data-target="#ph-l2"></i>
													{elseif $measure.water_ph < 6.4}
														<i class="fa fa-arrow-circle-o-up text-warning" data-toggle="modal" data-target="#ph-l1"></i>
													{elseif $measure.water_ph > 8.1}													
														<i class="fa fa-arrow-circle-down text-danger" data-toggle="modal" data-target="#ph-h2"></i>														
													{elseif $measure.water_ph > 7.5}													
														<i class="fa fa-arrow-circle-o-down text-warning" data-toggle="modal" data-target="#ph-h1"></i>
													{else}
														<i class="fa fa-thumbs-o-up text-success"></i>
													{/if}
												{else}-{/if}
											</td>
											<td>{if $measure.water_gh != null}
													{$measure.water_gh} 
													{if $measure.water_gh < 4}
														<i class="fa fa-arrow-circle-up text-danger" data-toggle="modal" data-target="#gh-l2"></i>
													{elseif $measure.water_gh < 7}
														<i class="fa fa-arrow-circle-o-up text-warning" data-toggle="modal" data-target="#gh-l1"></i>
													{elseif $measure.water_gh > 18}													
														<i class="fa fa-arrow-circle-down text-danger" data-toggle="modal" data-target="#gh-h2"></i>														
													{elseif $measure.water_gh > 14}													
														<i class="fa fa-arrow-circle-o-down text-warning" data-toggle="modal" data-target="#gh-h1"></i>
													{else}
														<i class="fa fa-thumbs-o-up text-success"></i>
													{/if}
												{else}-{/if}
											</td>
											<td>{if $measure.water_kh != null}
													{$measure.water_kh} 
													{if $measure.water_kh < 2}
														<i class="fa fa-arrow-circle-up text-danger" data-toggle="modal" data-target="#kh-l2"></i>
													{elseif $measure.water_kh < 4}
														<i class="fa fa-arrow-circle-o-up text-warning" data-toggle="modal" data-target="#kh-l1"></i>
													{elseif $measure.water_kh > 14}													
														<i class="fa fa-arrow-circle-down text-danger" data-toggle="modal" data-target="#kh-h2"></i>														
													{elseif $measure.water_kh > 8}													
														<i class="fa fa-arrow-circle-o-down text-warning" data-toggle="modal" data-target="#kh-h1"></i>
													{else}
														<i class="fa fa-thumbs-o-up text-success"></i>
													{/if}
												{else}-{/if}
											</td>
											<td>{if $measure.water_no2 != null}
													{$measure.water_no2} 
													{if $measure.water_no2 > 0.2}
														<i class="fa fa-arrow-circle-down text-danger" data-toggle="modal" data-target="#no2-h"></i>														
													{else}
														<i class="fa fa-thumbs-o-up text-success"></i>
													{/if}
												{else}-{/if}
											</td>
											<td>{if $measure.water_no3 != null}
													{$measure.water_no3} 
													{if $measure.water_no3 < 5}
														<i class="fa fa-arrow-circle-up text-danger" data-toggle="modal" data-target="#no3-l2"></i>
													{elseif $measure.water_no3 < 10}
														<i class="fa fa-arrow-circle-o-up text-warning" data-toggle="modal" data-target="#no3-l1"></i>
													{elseif $measure.water_no3 > 40}													
														<i class="fa fa-arrow-circle-down text-danger" data-toggle="modal" data-target="#no3-h2"></i>														
													{elseif $measure.water_no3 > 20}													
														<i class="fa fa-arrow-circle-o-down text-warning" data-toggle="modal" data-target="#no3-h1"></i>
													{else}
														<i class="fa fa-thumbs-o-up text-success"></i>
													{/if}
												{else}-{/if}
											</td>
											<td>{if $measure.water_cl2 != null}
													{$measure.water_cl2} 
													{if $measure.water_cl2 >= 0.1}
														<i class="fa fa-arrow-circle-down text-danger" data-toggle="modal" data-target="#cl2-h"></i>														
													{else}
														<i class="fa fa-thumbs-o-up text-success"></i>
													{/if}
												{else}-{/if}
											</td>
											<td>{$measure.water_comment}</td>
											<td>
												<a href="?action=delete&waterid={$measure.water_id}" onClick="return confirmLink(this,'Czy jesteś pewien, że chcesz skasować ten pomiar?');" class="btn btn-danger btn-sm">
													<i class="fa fa-times"></i> Usuń
												</a>
											</td>											
										</tr>
								{foreachelse}
										<tr>
											<td colspan="8">Brak pomiarów</td>								
										</tr>
								{/foreach}
									</tbody>
								</table>
							</div>
							<div class="card-footer">
								<p>Ogólnie rzecz biorąc przyjmuje się, że idealna dla akwariów roślinnych twardość węglanowa powinna wynosić 5-8 stopni niemieckich. 
								Teoretycznie, jeśli utrzymamy KH i pH na odpowiednim poziomie, ilość rozpuszczonego w wodzie CO<sub>2</sub> będzie wystarczająca do prowadzenia z 
								powodzeniem akwarium roślinnego.</p>
							</div>
						</section>
                    </div>
				</div>
			</div>
		</div>
				
{include "footer.tpl"}