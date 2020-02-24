{include "header.tpl"}
        <div class="content mt-3">
            <div class="animated fadeIn">
                <div class="row">
                    <div class="col-lg-12">
						<form action="water.php?action=add" method="post" class="form-horizontal">
							<section class="card">
								<div class="card-header">
									<div class="col-md-12">
										<strong class="card-title" v-if="headerText">Dodaj nowy pomiar</strong>
									</div>
								</div>							
								<div class="card-body card-block">
									<div class="row form-group">
										<div class="col-2">Data pomiaru:</div>
										<div class="col-2"><input class="form-control" type="date" name="date" value="{$smarty.now|date_format:"%Y-%m-%d"}" required></div>

										<div class="col-2">Komentarz:</div>
										<div class="col-6"><input class="form-control" type="text" name="comment"></div>
									</div>								
									<div class="row form-group">
										<div class="col-2  input-group">
											<p>pH&nbsp;</p>
											<input class="form-control" type="number" name="ph" id="ph" step="0.1">
										</div>
										<div class="col-2  input-group">
											<p>GH&nbsp;</p>
											<input class="form-control" type="number" name="gh" id="gh" step="0.1">
										</div>										
										<div class="col-2  input-group">
											<p>KH&nbsp;</p>
											<input class="form-control" type="number" name="kh" id="kh" step="0.1">
										</div>
										<div class="col-2  input-group">
											<p>NO<sub>2</sub>&nbsp;</p>
											<input class="form-control" type="number" name="no2" id="no2" step="0.1">
										</div>
										<div class="col-2  input-group">
											<p>NO<sub>3</sub>&nbsp;</p>
											<input class="form-control" type="number" name="no3" id="no3" step="0.1">
										</div>
										<div class="col-2  input-group">
											<p>CL<sub>2</sub>&nbsp;</p>
											<input class="form-control" type="number" name="cl2" id="cl2" step="0.1">
										</div>									
									</div>
								</div>
								<div class="card-footer">
									<button type="submit" class="btn btn-primary btn-sm">
										<i class="fa fa-save"></i> Zapisz
									</button>
								</div>
							</section>
						</form>
                    </div>
				</div>
			</div>
		</div>
				
{include "footer.tpl"}