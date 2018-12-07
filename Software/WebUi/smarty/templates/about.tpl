{include "header.tpl"}
        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="ui-typography">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-header">
                                    <strong class="card-title" v-if="headerText">Sterownik akwariowy AquaPi wersja {$aquapi_ver}</strong>
                                </div>
                                <div class="card-body">
									<div class="typo-articles">
                                        <p>
											Sterownik (sprzęt jak i oprogramowanie) dostępny jest na licencji GNU GPL w wersji 2.0.<br/>
											Pełen tekst licencji można znaleźć <a href="http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt">tutaj</a>, a skrócone objaśnienie <a href="http://pl.wikipedia.org/wiki/GNU_General_Public_License">tutaj</a>.<br/>
										</p>
										<p>Autorami są lub byli:</p>
											<div class="col-md-12">
											<ul>
												<li><a href="http://lexx.polarnet.pl/">Marcin 'Lexx' Król</a></li>
												<li><a href="http://www.czarniak.org">Jarosław 'Sir_Yaro' Czarniak</a></li>
											</ul>
											</div>
										<p>Pliki projektu można znaleźć w repezytorium GitHub pod adresem <a href="https://github.com/lexx-polarnet-pl/AquaPi">https://github.com/lexx-polarnet-pl/AquaPi</a><br/></p>
										<p>Inspiracją dla projektu był już nie rozwijany <a href="https://github.com/musashimm/aquamat">Aquamat</a><br/></p>
										<p>Interfejs web zawiera elementy pochodzące od Google (licencjonowane inaczej niż GPL) tj:<br/></p>
											<div class="col-md-12">
											<ul>
												<li style="text-decoration: line-through;">Google Chart Tools</li>
												<li>Capriola Web Font</li>
											</ul>
											</div>
										<p>Pozostałe elementy wchodzące w skład sterownika to:</p>
											<div class="col-md-12">
											<ul>
												<li>Biblioteka wiring Pi</li>
												<li>Biblioteka inih</li>
												<li>Smarty</li>
												<li>jquery</li>
												<li style="text-decoration: line-through;">PHP-Calendar DO WYWALENIA</li>
												<li style="text-decoration: line-through;">ikonki Crystal project DO WYWALENIA</li>
												<li style="text-decoration: line-through;">PHP Mobile Detect DO WYWALENIA</li>
												<li>Sufee Admin</li>
												<li>oraz oczywiście Raspbian </li>
											</ul>
											</div>
										</p>
									</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div><!-- .animated -->
        </div><!-- .content -->
{include "footer.tpl"}