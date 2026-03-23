<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output  method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">
		<SCRIPT LANGUAGE="JavaScript" SRC="../App_Themes/Classic/CalendarPopup.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript">
			var cal = new CalendarPopup();
			function post() {
			document.forms[0].action = 'AgentLineMover.aspx';
			document.forms[0].submit();
			}

			function ResetLine(Send) {
			document.forms[0].action = 'AgentLineMover.aspx?RS=' + Send;
			document.forms[0].submit();
			}

			<!--function GetGameEventDetail(Send) {
			$.get('/Popup/EventSchedule.aspx?INIT=' + Send, function (data) {
			var content = $(data);
			var divContent = content.find('#ctl00_PopUpContent_UpdatePanelReport').html();
			$('#PopUpModal .modal-body').html(divContent);
			$('#PopUpModal').modal('show');
			});
			}-->

			function GetGameEventDetail(Send) {
			window.open('../Popup/EventSchedule.aspx?INIT=' + Send, 'Events', 'width='+screen.availWidth-10+',height=600,resizable=yes,scrollbars=yes');
			}

			let lastChanged = null;

			// Guarda el ID del último campo modificado
			document.addEventListener('input', (e) => {
			if (e.target.matches('input, select, textarea')) {
			lastChanged = e.target.id;
			}
			});

			// Antes de enviar el formulario, agrega el #anchor
			function goToLastAfterSave(form) {
			if (lastChanged) {
			form.action = form.action.split('#')[0] + '#' + lastChanged;
			}
			return true; // permite el submit normal
			}
		</SCRIPT>




		<center>
			<div class="row">
				<div class="page-titles">
					<h4>Agent Line Mover</h4>
				</div>
			</div>
			<div class="container-fluid mb-3">
				<div class="card shadow-sm border-0">
					<div class="card-body">
						<form method="post" action="AgentLineMover.aspx">
							<div class="row g-3 align-items-end">
								<div class="col-12 col-md-3">
									<div class="d-flex align-items-center justify-content-between">
										<label for="cmbSport" class="form-label mb-0 me-2 flex-shrink-0 small">Sports</label>
										<select class="form-select form-select-sm tomlist w-100" name="cmbSport" onchange="post();">
											<xsl:for-each select="idsport">
												<option value="{@Value}">
													<xsl:if test="@Selected='1'">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="@Text" />
												</option>
											</xsl:for-each>
										</select>
									</div>
								</div>

								<div class="col-12 col-md-3">
									<div class="d-flex align-items-center justify-content-between">
										<label for="cmbLeague" class="form-label mb-0 me-2 flex-shrink-0 small">League</label>
										<select class="form-select form-select-sm tomlist w-100" name="cmbLeague" onchange="post();">
											<xsl:for-each select="league">
												<option value="{@Value}">
													<xsl:if test="@Selected='1'">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="@Text" />
												</option>
											</xsl:for-each>
										</select>
									</div>
								</div>

								<div class="col-12 col-md-3">
									<div class="d-flex align-items-center justify-content-between">
										<label for="cmbPeriod" class="form-label mb-0 me-2 flex-shrink-0 small">Period</label>
										<select class="form-select form-select-sm tomlist w-100" name="cmbPeriod" onchange="post();">
											<xsl:for-each select="period">
												<option value="{@Value}">
													<xsl:if test="@Selected='1'">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="@Text" />
												</option>
											</xsl:for-each>
										</select>
									</div>
								</div>

								<div class="col-12 col-md-3">
									<div class="d-flex align-items-center justify-content-between">
										<label for="cmbOrder" class="form-label mb-0 me-2 flex-shrink-0 small">Order</label>
										<select class="form-select form-select-sm tomlist w-100" name="cmbOrder" onchange="post();">
											<xsl:for-each select="order">
												<option value="{@Value}">
													<xsl:if test="@Selected='1'">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>
													<xsl:value-of select="@Text" />
												</option>
											</xsl:for-each>
										</select>
									</div>
								</div>


							</div>
							</form>
					</div>
				</div>

			</div>
			<input type="hidden" name="TabChanged" id="TabChanged" value="" />

			<xsl:if test="//xml/@Sport = 'NFL' or //xml/@Sport = 'CFB' or //xml/@Sport = 'NBA' or //xml/@Sport = 'CBB'">
				<xsl:for-each select="GameValues">


					<table class="table-dynamic table table-bordered table-striped">
						<thead>
							<xsl:if test="@GameDescription != '' ">
								<tr class="table-title text-center">
									<th>
										<xsl:value-of select="@GameDescription"/>
									</th>
								</tr>
							</xsl:if>
							<tr class="d-table-row d-md-none">
								<th colspan="100%" class="text-center">
									<span class="text12">[<xsl:value-of select="@VisitorNumber"/>] </span> <xsl:value-of select="@VisitorTeam"/>
									vs
									<span class="text12">[<xsl:value-of select="@HomeNumber"/>] </span> <xsl:value-of select="@HomeTeam"/>
								</th>
							</tr>
							<tr>
								
								<th class="text12 text-center"><xsl:value-of select="@GameDateTime"/></th>
							</tr>
						</thead>
					</table>

					
					<div class="table-responsive">
						<table cellspacing="0" cellpadding="0" border="0" width="100%" style="border:solid 1px #000;">
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
									<xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							
							<tr class="TRTitle">
								
								<td class="d-none d-md-table-cell" style="width:15%;border-bottom:solid 1px #000;">Game</td>
								<td style="width:13%;border-bottom:solid 1px #000;">
									Spread
								</td>
								<td style="width:13%;border-bottom:solid 1px #000;">
									Odds
								</td>
								<td style="width:13%;border-bottom:solid 1px #000;">
									Total
								</td>
								<td style="width:13%;border-bottom:solid 1px #000;">
									Odds
								</td>
								<td style="width:13%;border-bottom:solid 1px #000;">
									$-Line
								</td>
							</tr>
							<tr>

								<td class="d-none d-md-table-cell"  style="border-right:solid 1px #000;">
									[<xsl:value-of select="@VisitorNumber"/>] <xsl:value-of select="@VisitorTeam"/>
									<br />
									[<xsl:value-of select="@HomeNumber"/>]<xsl:value-of select="@HomeTeam"/>
								</td>
								<xsl:if test="@HideGame = 'False'">
									<td>
										<xsl:if test="@HideSpread = 'False'">
											<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
												<tr>
													<td style="width:70%;">
														<xsl:value-of select="@VisitorSpread"/>
														<xsl:if test="@AgVisitorSpread != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgVisitorSpread"/>
															</font>]
														</xsl:if>
													</td>
													<td>


														<input type="text" id="txt_vsp_{@IdGame}_3" name="txt_vsp_{@IdGame}_3" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsp_' + {@IdGame} + '_3', '{@VisitorSpread}', '{@AgVisitorSpread}', 'Spread')" autocomplete="off"/>

													</td>
												</tr>
												<tr>
													<td>
														<xsl:value-of select="@HomeSpread"/>
														<xsl:if test="@AgHomeSpread != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgHomeSpread"/>
															</font>]
														</xsl:if>
													</td>
													<td>


														<input type="text" id="txt_hsp_{@IdGame}_3" name="txt_hsp_{@IdGame}_3" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsp_' + {@IdGame}  + '_3', '{@HomeSpread}', '{@AgHomeSpread}', 'Spread')" autocomplete="off" />

													</td>
												</tr>
											</table>
										</xsl:if>
									</td>
									<td>
										<xsl:if test="@HideSpread = 'False'">
											<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
												<tr>
													<td style="width:70%;">
														<xsl:value-of select="@VisitorSpreadOdds"/>
														<xsl:if test="@AgVisitorSpreadOdds != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgVisitorSpreadOdds"/>
															</font>]
														</xsl:if>
													</td>
													<td>

														<input type="text" id="txt_vso_{@IdGame}_4" name="txt_vso_{@IdGame}_4" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vso_' + {@IdGame}  + '_4', '{@VisitorSpreadOdds}', '{@AgVisitorSpreadOdds}', 'Odds')" autocomplete="off" />

													</td>
												</tr>
												<tr>
													<td>
														<xsl:value-of select="@HomeSpreadOdds"/>
														<xsl:if test="@AgHomeSpreadOdds != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgHomeSpreadOdds"/>
															</font>]
														</xsl:if>
													</td>
													<td>

														<input type="text" id="txt_hso_{@IdGame}_4" name="txt_hso_{@IdGame}_4" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hso_' + {@IdGame}  + '_4', '{@HomeSpreadOdds}', '{@AgHomeSpreadOdds}', 'Odds')" autocomplete="off" />

													</td>
												</tr>
											</table>
										</xsl:if>
									</td>
									<td>
										<xsl:if test="@HideTotal = 'False'">
											<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
												<tr>
													<td style="width:70%;">
														<xsl:value-of select="@TotalOver"/>
														<xsl:if test="@AgTotalOver != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgTotalOver"/>
															</font>]
														</xsl:if>
													</td>
													<td>


														<input type="text" id="txt_tov_{@IdGame}_7" name="txt_tov_{@IdGame}_7" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tov_' + {@IdGame}  + '_7', '{@TotalOver}', '{@AgTotalOver}', 'Points')" autocomplete="off"/>

													</td>
												</tr>
												<tr>
													<td>
														<xsl:value-of select="@TotalUnder"/>
														<xsl:if test="@AgTotalUnder != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgTotalUnder"/>
															</font>]
														</xsl:if>
													</td>
													<td>


														<input type="text" id="txt_tun_{@IdGame}_7" name="txt_tun_{@IdGame}_7" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tun_' + {@IdGame}  + '_7', '{@TotalUnder}', '{@AgTotalUnder}', 'Points')" autocomplete="off"/>

													</td>
												</tr>
											</table>
										</xsl:if>
									</td>
									<td>
										<xsl:if test="@HideTotal = 'False'">
											<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
												<tr>
													<td style="width:70%;">
														<xsl:value-of select="@OverOdds"/>
														<xsl:if test="@AgOverOdds != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgOverOdds"/>
															</font>]
														</xsl:if>
													</td>
													<td>

														<input type="text" id="txt_ood_{@IdGame}_8" name="txt_ood_{@IdGame}_8" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_ood_' + {@IdGame}  + '_8', '{@OverOdds}', '{@AgOverOdds}', 'Odds')" autocomplete="off"/>

													</td>
												</tr>
												<tr>
													<td style="width:70%;">
														<xsl:value-of select="@UnderOdds"/>
														<xsl:if test="@AgUnderOdds != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgUnderOdds"/>
															</font>]
														</xsl:if>
													</td>
													<td>

														<input type="text" id="txt_uod_{@IdGame}_8" name="txt_uod_{@IdGame}_8" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_uod_' + {@IdGame}  + '_8', '{@UnderOdds}', '{@AgUnderOdds}', 'Odds')" autocomplete="off"/>

													</td>
												</tr>
											</table>
										</xsl:if>
									</td>
									<td>
										<xsl:if test="@HideMoneyLine = 'False'">
											<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
												<tr>
													<td style="width:70%;">
														<xsl:value-of select="@VisitorOdds"/>
														<xsl:if test="@AgVisitorOdds != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgVisitorOdds"/>
															</font>]
														</xsl:if>
													</td>
													<td>


														<input type="text" id="txt_vod_{@IdGame}_11" name="txt_vod_{@IdGame}_11" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_11', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>

													</td>
												</tr>
												<tr>
													<td>
														<xsl:value-of select="@HomeOdds"/>
														<xsl:if test="@AgHomeOdds != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgHomeOdds"/>
															</font>]
														</xsl:if>
													</td>
													<td>


														<input type="text" id="txt_hod_{@IdGame}_11" name="txt_hod_{@IdGame}_11" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_11', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>

													</td>
												</tr>
											</table>
										</xsl:if>
									</td>
								</xsl:if>
								<xsl:if test="@HideGame = 'True'">
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td></td>
								</xsl:if>
								
							</tr>
						</table>
					</div>
				
									<div class="container-fluid px-0 FollowLine p-2 border-top">
										<div class="row g-2 align-items-center">

											<div class="col-12 col-md-2 text-center text-md-start">
												<xsl:choose>
													<xsl:when test="@OffBoard = 'True'">
														<span class="badge bg-danger w-100">Off The Board</span>
													</xsl:when>
													<xsl:otherwise>
														<span class="badge bg-success w-100">Open Game</span>
													</xsl:otherwise>
												</xsl:choose>
											</div>

											<div class="col-12 col-md-10 text-center">
												<div class="fw-bold mb-1">Hide Options</div>

												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_HideGame_{@IdGame}" name="chk_HideGame_{@IdGame}" value="{@HideGame}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_HideGame_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@HideGame = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<label class="form-check-label small">Game</label>
												</div>

												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_HideSpread_{@IdGame}" name="chk_HideSpread_{@IdGame}" value="{@HideSpread}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_HideSpread_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@HideSpread = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<label class="form-check-label small">Spread</label>
												</div>

												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_HideTotal_{@IdGame}" name="chk_HideTotal_{@IdGame}" value="{@HideTotal}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_HideTotal_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@HideTotal = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<label class="form-check-label small">Total</label>
												</div>

												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_HideMoneyLine_{@IdGame}" name="chk_HideMoneyLine_{@IdGame}" value="{@HideMoneyLine}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_HideMoneyLine_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@HideMoneyLine = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<label class="form-check-label small">$ Line</label>
												</div>
											</div>

											<!-- Spread -->
											<div class="col-6 col-md-3 text-center">
												<div class="fw-bold mb-1">Follow Spread</div>
												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_FollowSpPoints_{@IdGame}" name="chk_FollowSpPoints_{@IdGame}" value="{@FollowSpreadPoints}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_FollowSpPoints_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@FollowSpreadPoints = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<label class="form-check-label small">Points</label>
												</div>
												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_FollowSpOdds_{@IdGame}" name="chk_FollowSpOdds_{@IdGame}" value="{@FollowSpreadOdds}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_FollowSpOdds_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@FollowSpreadOdds = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<label class="form-check-label small">Odds</label>
												</div>
											</div>

											

											<!-- Total -->
											<div class="col-6 col-md-3 text-center">
												<div class="fw-bold mb-1">Follow Total</div>
												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_FollowTtPoints_{@IdGame}" name="chk_FollowTtPoints_{@IdGame}" value="{@FollowTotalPoints}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_FollowTtPoints_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@FollowTotalPoints = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<label class="form-check-label small">Points</label>
												</div>
												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_FollowTtOdds_{@IdGame}" name="chk_FollowTtOdds_{@IdGame}" value="{@FollowTotalOdds}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_FollowTtOdds_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@FollowTotalOdds = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<label class="form-check-label small">Odds</label>
												</div>
											</div>

											<!-- Money Line -->
											<div class="col-12 col-md-3 text-center">
												<div class="fw-bold mb-1">Money Line</div>
												<div class="form-check form-check-inline">
													<input class="form-check-input" type="checkbox" id="chk_FollowMl_{@IdGame}" name="chk_FollowMl_{@IdGame}" value="{@FollowMoney}">
														<xsl:attribute name="onclick">
															<xsl:text>ChangeHD('chk_FollowMl_</xsl:text>
															<xsl:value-of select="@IdGame"/>
															<xsl:text>')</xsl:text>
														</xsl:attribute>
														<xsl:if test="@FollowMoney = 'True'">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
												</div>
											</div>

											<div class="col-6 col-md-1 text-end">
												<input type="button" class="btn btn-sm btn-outline-warning w-100" value="Events">
													<xsl:attribute name="onclick">
														<xsl:text>GetGameEventDetail('</xsl:text>
														<xsl:value-of select="@IdGame"/>
														<xsl:text>')</xsl:text>
													</xsl:attribute>
												</input>
											</div>

											<div class="col-6 col-md-1 text-end">

												<input type="button" class="btn btn-sm btn-outline-danger w-100" value="Re-Set">
													<xsl:attribute name="onclick">
														<xsl:text>ResetLine('</xsl:text>
														<xsl:value-of select="@IdGame"/>
														<xsl:text>_</xsl:text>
														<xsl:value-of select="//xml/@Sport"/>
														<xsl:text>')</xsl:text>
													</xsl:attribute>
												</input>
											</div>

										</div>
									</div>
								
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="//xml/@Sport = 'MU' or //xml/@Sport = 'SOC'">
				<xsl:for-each select="GameValues">
					<table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
								<xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="@GameDescription != '' ">
							<tr class="TRTitle">
								<td colspan="9" align="center">
									<xsl:value-of select="@GameDescription"/>
								</td>
							</tr>
						</xsl:if>
						<tr class="TRTitle">
							<td style="width:7%;border-bottom:solid 1px #000;">D/T</td>
							<td style="width:4%;border-bottom:solid 1px #000;">#</td>
							<td style="width:15%;border-bottom:solid 1px #000;">Team Name</td>
							<td style="width:13%;border-bottom:solid 1px #000;">$-Ln</td>
							<td style="width:13%;border-bottom:solid 1px #000;">Total</td>
							<td style="width:13%;border-bottom:solid 1px #000;">Odds</td>
							<xsl:if test="//xml/@Sport = 'MU'">
								<td style="border-bottom:solid 1px #000;">Spread</td>
							</xsl:if>
							<xsl:if test="//xml/@Sport = 'SOC'">
								<td style="border-bottom:solid 1px #000;">Goals</td>
							</xsl:if>
							<td style="width:13%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
						</tr>

						<tr>

							<td>
								<xsl:value-of select="@GameDateTime"/>
							</td>
							<td>
								<xsl:value-of select="@VisitorNumber"/>
								<br />
								<xsl:value-of select="@HomeNumber"/>
								<xsl:if test="//xml/@Sport = 'SOC'">
									<br />
									<xsl:value-of select="(@HomeNumber + 1)"/>
								</xsl:if>
							</td>
							<td>
								<xsl:value-of select="@VisitorTeam"/>
								<br />
								<xsl:value-of select="@HomeTeam"/>
								<xsl:if test="//xml/@Sport = 'SOC'">
									<br />
									DRAW
								</xsl:if>
							</td>
							<xsl:if test="@HideGame = 'False'">
								<td>
									<xsl:if test="@HideMoneyLine = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorOdds"/>
													<xsl:if test="@AgVisitorOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_vod_{@IdGame}_3" name="txt_vod_{@IdGame}_3" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_3', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeOdds"/>
													<xsl:if test="@AgHomeOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_hod_{@IdGame}_3" name="txt_hod_{@IdGame}_3" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_3', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
											<xsl:if test="//xml/@Sport = 'SOC'">
												<tr>
													<td>
														<xsl:value-of select="@VisitorSpecialOdds"/>
														<xsl:if test="@AgVisitorSpecialOdds != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgVisitorSpecialOdds"/>
															</font>]
														</xsl:if>
													</td>
													<td>
														
														
															<input type="text" id="txt_vss_{@IdGame}_3" name="txt_vss_{@IdGame}_3" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vss_' + {@IdGame}  + '_3', '{@VisitorSpecialOdds}', '{@AgVisitorSpecialOdds}', 'Odds')" autocomplete="off"/>
														
													</td>
												</tr>
											</xsl:if>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideTotal = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@TotalOver"/>
													<xsl:if test="@AgTotalOver != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgTotalOver"/>
														</font>]
													</xsl:if>
												</td>
												<td>	
													
														<input type="text" id="txt_tov_{@IdGame}_5" name="txt_tov_{@IdGame}_5" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tov_' + {@IdGame}  + '_5', '{@TotalOver}', '{@AgTotalOver}', 'Points')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@TotalUnder"/>
													<xsl:if test="@AgTotalUnder != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgTotalUnder"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_tun_{@IdGame}_5" name="txt_tun_{@IdGame}_5" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tun_' + {@IdGame}  + '_5', '{@TotalUnder}', '{@AgTotalUnder}', 'Points')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideTotal = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@OverOdds"/>
													<xsl:if test="@AgOverOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgOverOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_ood_{@IdGame}_7" name="txt_ood_{@IdGame}_7" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_ood_' + {@IdGame}  + '_7', '{@OverOdds}', '{@AgOverOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@UnderOdds"/>
													<xsl:if test="@AgUnderOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgUnderOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_uod_{@IdGame}_7" name="txt_uod_{@IdGame}_7" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_uod_' + {@IdGame}  + '_7', '{@UnderOdds}', '{@AgUnderOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideSpread = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpread"/>
													<xsl:if test="@AgVisitorSpread != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpread"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_vsp_{@IdGame}_10" name="txt_vsp_{@IdGame}_10" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsp_' + {@IdGame} + '_10', '{@VisitorSpread}', '{@AgVisitorSpread}', 'Spread')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeSpread"/>
													<xsl:if test="@AgHomeSpread != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeSpread"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_hsp_{@IdGame}_10" name="txt_hsp_{@IdGame}_10" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsp_' + {@IdGame}  + '_10', '{@HomeSpread}', '{@AgHomeSpread}', 'Spread')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideSpread = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpreadOdds"/>
													<xsl:if test="@AgVisitorSpreadOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpreadOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_vso_{@IdGame}_11" name="txt_vso_{@IdGame}_11" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vso_' + {@IdGame}  + '_11', '{@VisitorSpreadOdds}', '{@AgVisitorSpreadOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeSpreadOdds"/>
													<xsl:if test="@AgHomeSpreadOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeSpreadOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_hso_{@IdGame}_11" name="txt_hso_{@IdGame}_11" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hso_' + {@IdGame}  + '_11', '{@HomeSpreadOdds}', '{@AgHomeSpreadOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
							</xsl:if>
							<xsl:if test="@HideGame = 'True'">
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</xsl:if>
							<td>
								<table cellspacing="0" cellpadding="0" border="0">
									<tr>
										<td align="right">
											Game
											<INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
												<xsl:if test="@HideGame = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											<xsl:if test="//xml/@Sport = 'MU'">
												Spread
											</xsl:if>
											<xsl:if test="//xml/@Sport = 'SOC'">
												Goal
											</xsl:if>
											<INPUT id="chk_HideSpread_{@IdGame}" type="checkbox" name="chk_HideSpread_{@IdGame}" value="{@HideSpread}" onclick="ChangeHD('chk_HideSpread_' + {@IdGame});">
												<xsl:if test="@HideSpread = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											Total
											<INPUT id="chk_HideTotal_{@IdGame}" type="checkbox" name="chk_HideTotal_{@IdGame}" value="{@HideTotal}" onclick="ChangeHD('chk_HideTotal_' + {@IdGame});">
												<xsl:if test="@HideTotal = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											$-Line
											<INPUT id="chk_HideMoneyLine_{@IdGame}" type="checkbox" name="chk_HideMoneyLine_{@IdGame}" value="{@HideMoneyLine}" onclick="ChangeHD('chk_HideMoneyLine_' + {@IdGame});">
												<xsl:if test="@HideMoneyLine = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr class="FollowLine">
							<td colspan="2" style="border-top:solid 1px #000;">
								<xsl:if test="@OffBoard = 'True'">
									Off The Board
								</xsl:if>
								<xsl:if test="@OffBoard = 'False'">
									Open Game
								</xsl:if>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								Follow: Spread Points
								<INPUT id="chk_FollowSpPoints_{@IdGame}" type="checkbox" name="chk_FollowSpPoints_{@IdGame}" value="{@FollowSpreadPoints}" onclick="ChangeHD('chk_FollowSpPoints_' + {@IdGame});">
									<xsl:if test="@FollowSpreadPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
								<xsl:text>  </xsl:text>
								<br/>Spread Odds
								<INPUT id="chk_FollowSpOdds_{@IdGame}" type="checkbox" name="chk_FollowSpOdds_{@IdGame}" value="{@FollowSpreadOdds}" onclick="ChangeHD('chk_FollowSpOdds_' + {@IdGame});">
									<xsl:if test="@FollowSpreadOdds = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								$Line
								<INPUT id="chk_FollowMl_{@IdGame}" type="checkbox" name="chk_FollowMl_{@IdGame}" value="{@FollowMoney}" onclick="ChangeHD('chk_FollowMl_' + {@IdGame});">
									<xsl:if test="@FollowMoney = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								Total Points
								<INPUT id="chk_FollowTtPoints_{@IdGame}" type="checkbox" name="chk_FollowTtPoints_{@IdGame}" value="{@FollowTotalPoints}" onclick="ChangeHD('chk_FollowTtPoints_' + {@IdGame});">
									<xsl:if test="@FollowTotalPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
								<xsl:text>  </xsl:text>
								<br/>Total Odds
								<INPUT id="chk_FollowTtOdds_{@IdGame}" type="checkbox" name="chk_FollowTtOdds_{@IdGame}" value="{@FollowTotalOdds}" onclick="ChangeHD('chk_FollowTtOdds_' + {@IdGame});">
									<xsl:if test="@FollowTotalOdds = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td colspan="3" align="Right" style="border-top:solid 1px #000;">
								<INPUT type="button" class="btReset" id="Event_{@IdGame}" name="Event_{@IdGame}" value="Events" onclick="GetGameEventDetail({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
							<td align="right" style="border-top:solid 1px #000;">
								<INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetLine({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
						</tr>
					</table>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="//xml/@Sport = 'MLB'">
				<xsl:for-each select="GameValues">
					<table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
								<xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="@GameDescription != '' ">
							<tr class="TRTitle">
								<td colspan="9" align="center">
									<xsl:value-of select="@GameDescription"/>
								</td>
							</tr>
						</xsl:if>
						<tr class="TRTitle">
							<td style="width:7%;border-bottom:solid 1px #000;">D/T</td>
							<td style="width:4%;border-bottom:solid 1px #000;">#</td>
							<td style="width:15%;border-bottom:solid 1px #000;">Team Name</td>
							<td style="width:13%;border-bottom:solid 1px #000;">$-Ln</td>
							<td style="width:13%;border-bottom:solid 1px #000;">Total</td>
							<td style="width:13%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:13%;border-bottom:solid 1px #000;">R-L</td>
							<td style="width:13%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
						</tr>

						<tr>

							<td>
								<xsl:value-of select="@GameDateTime"/>
							</td>
							<td>
								<xsl:value-of select="@VisitorNumber"/>
								<br />
								<xsl:value-of select="@HomeNumber"/>
							</td>
							<td>
								<xsl:value-of select="@VisitorTeam"/>
								<br />
								<xsl:value-of select="@HomeTeam"/>
							</td>
							<xsl:if test="@HideGame = 'False'">
								<td>
									<xsl:if test="@HideMoneyLine = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorOdds"/>
													<xsl:if test="@AgVisitorOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
														<input type="text" id="txt_vod_{@IdGame}_4" name="txt_vod_{@IdGame}_4" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_4', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeOdds"/>
													<xsl:if test="@AgHomeOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_hod_{@IdGame}_4" name="txt_hod_{@IdGame}_4" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_4', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideTotal = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@TotalOver"/>
													<xsl:if test="@AgTotalOver != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgTotalOver"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_tov_{@IdGame}_7" name="txt_tov_{@IdGame}_7" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tov_' + {@IdGame}  + '_7', '{@TotalOver}', '{@AgTotalOver}', 'Points')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@TotalUnder"/>
													<xsl:if test="@AgTotalUnder != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgTotalUnder"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_tun_{@IdGame}_7" name="txt_tun_{@IdGame}_7" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tun_' + {@IdGame}  + '_7', '{@TotalUnder}', '{@AgTotalUnder}', 'Points')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideTotal = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@OverOdds"/>
													<xsl:if test="@AgOverOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgOverOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_ood_{@IdGame}_8" name="txt_ood_{@IdGame}_8" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_ood_' + {@IdGame}  + '_8', '{@OverOdds}', '{@AgOverOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@UnderOdds"/>
													<xsl:if test="@AgUnderOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgUnderOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_uod_{@IdGame}_8" name="txt_uod_{@IdGame}_8" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_uod_' + {@IdGame}  + '_8', '{@UnderOdds}', '{@AgUnderOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideSpread = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpread"/>
													<xsl:if test="@AgVisitorSpread != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpread"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_vsp_{@IdGame}_11" name="txt_vsp_{@IdGame}_11" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsp_' + {@IdGame} + '_11', '{@VisitorSpread}', '{@AgVisitorSpread}', 'Spread')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeSpread"/>
													<xsl:if test="@AgHomeSpread != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeSpread"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_hsp_{@IdGame}_11" name="txt_hsp_{@IdGame}_11" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsp_' + {@IdGame}  + '_11', '{@HomeSpread}', '{@AgHomeSpread}', 'Spread')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideSpread = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpreadOdds"/>
													<xsl:if test="@AgVisitorSpreadOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpreadOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_vso_{@IdGame}_12" name="txt_vso_{@IdGame}_12" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vso_' + {@IdGame}  + '_12', '{@VisitorSpreadOdds}', '{@AgVisitorSpreadOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeSpreadOdds"/>
													<xsl:if test="@AgHomeSpreadOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeSpreadOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_hso_{@IdGame}_12" name="txt_hso_{@IdGame}_12" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hso_' + {@IdGame}  + '_12', '{@HomeSpreadOdds}', '{@AgHomeSpreadOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
							</xsl:if>
							<xsl:if test="@HideGame = 'True'">
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</xsl:if>
							<td>
								<table cellspacing="0" cellpadding="0" border="0">
									<tr>
										<td align="right">
											Game
											<INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
												<xsl:if test="@HideGame = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											R-L
											<INPUT id="chk_HideSpread_{@IdGame}" type="checkbox" name="chk_HideSpread_{@IdGame}" value="{@HideSpread}" onclick="ChangeHD('chk_HideSpread_' + {@IdGame});">
												<xsl:if test="@HideSpread = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											Total
											<INPUT id="chk_HideTotal_{@IdGame}" type="checkbox" name="chk_HideTotal_{@IdGame}" value="{@HideTotal}" onclick="ChangeHD('chk_HideTotal_' + {@IdGame});">
												<xsl:if test="@HideTotal = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											$-Line
											<INPUT id="chk_HideMoneyLine_{@IdGame}" type="checkbox" name="chk_HideMoneyLine_{@IdGame}" value="{@HideMoneyLine}" onclick="ChangeHD('chk_HideMoneyLine_' + {@IdGame});">
												<xsl:if test="@HideMoneyLine = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr class="FollowLine">
							<td colspan="2" style="border-top:solid 1px #000;">
								<xsl:if test="@OffBoard = 'True'">
									Off The Board
								</xsl:if>
								<xsl:if test="@OffBoard = 'False'">
									Open Game
								</xsl:if>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								Follow: Spread Points
								<INPUT id="chk_FollowSpPoints_{@IdGame}" type="checkbox" name="chk_FollowSpPoints_{@IdGame}" value="{@FollowSpreadPoints}" onclick="ChangeHD('chk_FollowSpPoints_' + {@IdGame});">
									<xsl:if test="@FollowSpreadPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
								<xsl:text>  </xsl:text>
								<br/>Spread Odds
								<INPUT id="chk_FollowSpOdds_{@IdGame}" type="checkbox" name="chk_FollowSpOdds_{@IdGame}" value="{@FollowSpreadOdds}" onclick="ChangeHD('chk_FollowSpOdds_' + {@IdGame});">
									<xsl:if test="@FollowSpreadOdds = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								$Line
								<INPUT id="chk_FollowMl_{@IdGame}" type="checkbox" name="chk_FollowMl_{@IdGame}" value="{@FollowMoney}" onclick="ChangeHD('chk_FollowMl_' + {@IdGame});">
									<xsl:if test="@FollowMoney = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								Total Points
								<INPUT id="chk_FollowTtPoints_{@IdGame}" type="checkbox" name="chk_FollowTtPoints_{@IdGame}" value="{@FollowTotalPoints}" onclick="ChangeHD('chk_FollowTtPoints_' + {@IdGame});">
									<xsl:if test="@FollowTotalPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
								<xsl:text>  </xsl:text>
								<br/>Total Odds
								<INPUT id="chk_FollowTtOdds_{@IdGame}" type="checkbox" name="chk_FollowTtOdds_{@IdGame}" value="{@FollowTotalOdds}" onclick="ChangeHD('chk_FollowTtOdds_' + {@IdGame});">
									<xsl:if test="@FollowTotalOdds = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td colspan="3" align="Right" style="border-top:solid 1px #000;">
								<INPUT type="button" class="btReset" id="Event_{@IdGame}" name="Event_{@IdGame}" value="Events" onclick="GetGameEventDetail({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
							<td align="right" style="border-top:solid 1px #000;">
								<INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetLine({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
						</tr>
					</table>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test ="//xml/@Sport = 'NHL'">
				<xsl:for-each select="GameValues">
					<table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
								<xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="@GameDescription != '' ">
							<tr class="TRTitle">
								<td colspan="11" align="center">
									<xsl:value-of select="@GameDescription"/>
								</td>
							</tr>
						</xsl:if>
						<tr class="TRTitle">
							<td style="width:7%;border-bottom:solid 1px #000;">D/T</td>
							<td style="width:4%;border-bottom:solid 1px #000;">#</td>
							<td style="width:12%;border-bottom:solid 1px #000;">Team Name</td>
							<td style="width:10%;border-bottom:solid 1px #000;">$-Line</td>
							<td style="width:10%;border-bottom:solid 1px #000;">Total</td>
							<td style="width:10%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:10%;border-bottom:solid 1px #000;">C-L</td>
							<td style="width:10%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:10%;border-bottom:solid 1px #000;">A-L</td>
							<td style="width:10%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
						</tr>

						<tr>

							<td>
								<xsl:value-of select="@GameDateTime"/>
							</td>
							<td>
								<xsl:value-of select="@VisitorNumber"/>
								<br />
								<xsl:value-of select="@HomeNumber"/>
							</td>
							<td>
								<xsl:value-of select="@VisitorTeam"/>
								<br />
								<xsl:value-of select="@HomeTeam"/>
							</td>
							<xsl:if test="@HideGame = 'False'">
								<td>
									<xsl:if test="@HideMoneyLine = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorOdds"/>
													<xsl:if test="@AgVisitorOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_vod_{@IdGame}_3" name="txt_vod_{@IdGame}_3" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_3', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeOdds"/>
													<xsl:if test="@AgHomeOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_hod_{@IdGame}_3" name="txt_hod_{@IdGame}_3" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_3', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideTotal = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@TotalOver"/>
													<xsl:if test="@AgTotalOver != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgTotalOver"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
														<input type="text" id="txt_tov_{@IdGame}_6" name="txt_tov_{@IdGame}_6" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tov_' + {@IdGame}  + '_6', '{@TotalOver}', '{@AgTotalOver}', 'Points')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@TotalUnder"/>
													<xsl:if test="@AgTotalUnder != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgTotalUnder"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
														<input type="text" id="txt_tun_{@IdGame}_6" name="txt_tun_{@IdGame}_6" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tun_' + {@IdGame}  + '_6', '{@TotalUnder}', '{@AgTotalUnder}', 'Points')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideTotal = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@OverOdds"/>
													<xsl:if test="@AgOverOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgOverOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_ood_{@IdGame}_7" name="txt_ood_{@IdGame}_7" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_ood_' + {@IdGame}  + '_7', '{@OverOdds}', '{@AgOverOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@UnderOdds"/>
													<xsl:if test="@AgUnderOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgUnderOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_uod_{@IdGame}_7" name="txt_uod_{@IdGame}_7" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_uod_' + {@IdGame}  + '_7', '{@UnderOdds}', '{@AgUnderOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideSpread = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpecial"/>
													<xsl:if test="@AgVisitorSpecial!= ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpecial"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_vsl_{@IdGame}_10" name="txt_vsl_{@IdGame}_10" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsl_' + {@IdGame} + '_10', '{@VisitorSpecial}', '{@AgVisitorSpecial}', 'Spread')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeSpecial"/>
													<xsl:if test="@AgHomeSpecial != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeSpecial"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_hsl_{@IdGame}_10" name="txt_hsl_{@IdGame}_10" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsl_' + {@IdGame}  + '_10', '{@HomeSpecial}', '{@AgHomeSpecial}', 'Spread')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideSpread = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpecialOdds"/>
													<xsl:if test="@AgVisitorSpecialOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpecialOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_vss_{@IdGame}_11" name="txt_vss_{@IdGame}_11" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vss_' + {@IdGame}  + '_11', '{@VisitorSpecialOdds}', '{@AgVisitorSpecialOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeSpecialOdds"/>
													<xsl:if test="@AgHomeSpecialOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeSpecialOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_hss_{@IdGame}_11" name="txt_hss_{@IdGame}_11" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hss_' + {@IdGame}  + '_11', '{@HomeSpecialOdds}', '{@AgHomeSpecialOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideSpread = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpread"/>
													<xsl:if test="@AgVisitorSpread != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpread"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_vsp_{@IdGame}_14" name="txt_vsp_{@IdGame}_14" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsp_' + {@IdGame} + '_14', '{@VisitorSpread}', '{@AgVisitorSpread}', 'Spread')" autocomplete="off"/>
													
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeSpread"/>
													<xsl:if test="@AgHomeSpread != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeSpread"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_hsp_{@IdGame}_14" name="txt_hsp_{@IdGame}_14" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsp_' + {@IdGame}  + '_14', '{@HomeSpread}', '{@AgHomeSpread}', 'Spread')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideSpread = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpreadOdds"/>
													<xsl:if test="@AgVisitorSpreadOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpreadOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_vso_{@IdGame}_15" name="txt_vso_{@IdGame}_15" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vso_' + {@IdGame}  + '_15', '{@VisitorSpreadOdds}', '{@AgVisitorSpreadOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
											<tr>
												<td>
													<xsl:value-of select="@HomeSpreadOdds"/>
													<xsl:if test="@AgHomeSpreadOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeSpreadOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													<input type="text" id="txt_hso_{@IdGame}_15" name="txt_hso_{@IdGame}_15" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hso_' + {@IdGame}  + '_15', '{@HomeSpreadOdds}', '{@AgHomeSpreadOdds}', 'Odds')" autocomplete="off"/>
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
							</xsl:if>
							<xsl:if test="@HideGame = 'True'">
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
								<td></td>
							</xsl:if>
							<td>
								<table cellspacing="0" cellpadding="0" border="0">
									<tr>
										<td align="right">
											Game
											<INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
												<xsl:if test="@HideGame = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											Spread
											<INPUT id="chk_HideSpread_{@IdGame}" type="checkbox" name="chk_HideSpread_{@IdGame}" value="{@HideSpread}" onclick="ChangeHD('chk_HideSpread_' + {@IdGame});">
												<xsl:if test="@HideSpread = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											Total
											<INPUT id="chk_HideTotal_{@IdGame}" type="checkbox" name="chk_HideTotal_{@IdGame}" value="{@HideTotal}" onclick="ChangeHD('chk_HideTotal_' + {@IdGame});">
												<xsl:if test="@HideTotal = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
									<tr>
										<td align="right">
											$-Line
											<INPUT id="chk_HideMoneyLine_{@IdGame}" type="checkbox" name="chk_HideMoneyLine_{@IdGame}" value="{@HideMoneyLine}" onclick="ChangeHD('chk_HideMoneyLine_' + {@IdGame});">
												<xsl:if test="@HideMoneyLine = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr class="FollowLine">
							<td colspan="2" style="border-top:solid 1px #000;">
								<xsl:if test="@OffBoard = 'True'">
									Off The Board
								</xsl:if>
								<xsl:if test="@OffBoard = 'False'">
									Open Game
								</xsl:if>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								Follow: Spread Points
								<INPUT id="chk_FollowSpPoints_{@IdGame}" type="checkbox" name="chk_FollowSpPoints_{@IdGame}" value="{@FollowSpreadPoints}" onclick="ChangeHD('chk_FollowSpPoints_' + {@IdGame});">
									<xsl:if test="@FollowSpreadPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
								<xsl:text>  </xsl:text>
								<br/>Spread Odds
								<INPUT id="chk_FollowSpOdds_{@IdGame}" type="checkbox" name="chk_FollowSpOdds_{@IdGame}" value="{@FollowSpreadOdds}" onclick="ChangeHD('chk_FollowSpOdds_' + {@IdGame});">
									<xsl:if test="@FollowSpreadOdds = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								$Line
								<INPUT id="chk_FollowMl_{@IdGame}" type="checkbox" name="chk_FollowMl_{@IdGame}" value="{@FollowMoney}" onclick="ChangeHD('chk_FollowMl_' + {@IdGame});">
									<xsl:if test="@FollowMoney = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								Total Points
								<INPUT id="chk_FollowTtPoints_{@IdGame}" type="checkbox" name="chk_FollowTtPoints_{@IdGame}" value="{@FollowTotalPoints}" onclick="ChangeHD('chk_FollowTtPoints_' + {@IdGame});">
									<xsl:if test="@FollowTotalPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
								<xsl:text>  </xsl:text>
								<br/>Total Odds
								<INPUT id="chk_FollowTtOdds_{@IdGame}" type="checkbox" name="chk_FollowTtOdds_{@IdGame}" value="{@FollowTotalOdds}" onclick="ChangeHD('chk_FollowTtOdds_' + {@IdGame});">
									<xsl:if test="@FollowTotalOdds = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td colspan="5" align="Right" style="border-top:solid 1px #000;">
								<INPUT type="button" class="btReset" id="Event_{@IdGame}" name="Event_{@IdGame}" value="Events" onclick="GetGameEventDetail({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
							<td align="right" style="border-top:solid 1px #000;">
								<INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetLine({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
						</tr>
					</table>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="//xml/@Sport = 'TNT'">
				<xsl:for-each select="GameTNT">
					<table cellspacing="1" cellpadding="1" border="0" width="90%" style="border:solid 1px #000;">
						<xsl:if test="@GameDescription != '' ">
							<tr class="TRTitle">
								<td colspan="7" align="center">
									<xsl:value-of select="@GameDescription"/>
								</td>
							</tr>
						</xsl:if>
						<tr class="TrGameScheduleNon">
							<td style="width:17%;border-bottom:solid 1px #000;">CutOff</td>
							<td style="width:6%;border-bottom:solid 1px #000;">#</td>
							<td style="width:25%;border-bottom:solid 1px #000;">Description</td>
							<td style="width:20%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:25%;border-bottom:solid 1px #000;">Last Update</td>
							<td style="width:7%;border-bottom:solid 1px #000;">Hiden</td>
							<td style="width:7%;border-bottom:solid 1px #000;">FL</td>
						</tr>
						<tr class="GameHeader">
							<td>
								<xsl:value-of select ="@CutOfTime"/>
							</td>
							<td></td>
							<td>
								<xsl:value-of select ="@Description"/>
							</td>
							<td></td>
							<td></td>
							<td>
								<INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
									<xsl:if test="@HideGame = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td>
							</td>
						</tr>
						<xsl:for-each select="GameValues">
							<tr class="TrGameSchedulePar">
								<td></td>
								<td>
									<xsl:value-of select="@TeamNumber"/>
								</td>
								<td>
									<xsl:value-of select="@HomeTeam"/>
								</td>
								<xsl:if test="@HideGame = 'False'">
									<td>
										<xsl:if test="@HideGame = 'False'">
											<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
												<tr>
													<td style="width:70%;">
														<xsl:value-of select="@Odds"/>
														<xsl:if test="@AgOdds != ''">
															[<font class="AgScheduleColor">
																<xsl:value-of select="@AgOdds"/>
															</font>]
														</xsl:if>
													</td>
													<td>
														
														
															<input type="text" id="txt_odds_{@IdGame}_3_{@TeamNumber}" name="txt_odds_{@IdGame}_3_{@TeamNumber}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_odds_' + {@IdGame}  + '_3_' + {@TeamNumber}, '{@Odds}', '{@AgOdds}', 'Odds')" autocomplete="off"/>
														
													</td>
												</tr>
											</table>
										</xsl:if>
									</td>
								</xsl:if>
								<xsl:if test="@HideGame = 'True'">
									<td></td>
								</xsl:if>
								<td>
									<xsl:value-of select="@GameDateTime"/>
								</td>
								<td></td>
								<td>
									<INPUT id="chk_FollowMl_{@IdGame}_{@TeamNumber}" type="checkbox" name="chk_FollowMl_{@IdGame}_{@TeamNumber}" value="{@FollowSpread}" onclick="ChangeHD('chk_FollowMl_' + '{@IdGame}' + '_' + '{@TeamNumber}');">
										<xsl:if test="@FollowSpread = 'True'">
											<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
										</xsl:if>
									</INPUT>
								</td>
							</tr>
						</xsl:for-each>
						<tr class="FollowLine">
							<td colspan="4" style="border-top:solid 1px #000;">
								<xsl:if test="@OffBoard = 'True'">
									Off The Board
								</xsl:if>
								<xsl:if test="@OffBoard = 'False'">
									Open Game
								</xsl:if>
							</td>
							<td colspan="3" align="right" style="border-top:solid 1px #000;">
								<INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetLine({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
						</tr>
					</table>
				</xsl:for-each>
				<!---->
				<xsl:for-each select="GameValues">
					<table cellspacing="1" cellpadding="1" border="0" width="80%" style="border:solid 1px #000;">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
								<xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<tr>
							<td style="width:17%;border-bottom:solid 1px #000;">CutOff</td>
							<td style="width:6%;border-bottom:solid 1px #000;">#</td>
							<td style="width:25%;border-bottom:solid 1px #000;">Description</td>
							<td style="width:20%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:25%;border-bottom:solid 1px #000;">Last Update</td>
							<td style="width:7%;border-bottom:solid 1px #000;">Hiden</td>
						</tr>

						<tr>

							<td>
								<xsl:value-of select="@GameDateTime"/>
							</td>
							<td>
								<xsl:value-of select="@TeamNumber"/>
							</td>
							<td>
								<xsl:value-of select="@VisitorTeam"/>-<xsl:value-of select="@HomeTeam"/>
							</td>
							<xsl:if test="@HideGame = 'False'">
								<td>
									<xsl:if test="@HideGame = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@Odds"/>
													<xsl:if test="@AgOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_odds_{@IdGame}_3_{@TeamNumber}" name="txt_odds_{@IdGame}_3_{@TeamNumber}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_odds_' + {@IdGame}  + '_3_' + {@TeamNumber}, '{@Odds}', '{@AgOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
							</xsl:if>
							<xsl:if test="@HideGame = 'True'">
								<td></td>
							</xsl:if>
							<td>
								<xsl:value-of select="@GameDateTime"/>
							</td>
							<td>
								<table cellspacing="0" cellpadding="0" border="0">
									<tr>
										<td align="right">
											Game
											<INPUT id="chk_HideGame_{@IdGame}_{@TeamNumber}" type="checkbox" name="chk_HideGame_{@IdGame}_{@TeamNumber}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame}  + '_' + {@TeamNumber});">
												<xsl:if test="@HideGame = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr class="FollowLine">
							<td colspan="2" style="border-top:solid 1px #000;">
								<xsl:if test="@OffBoard = 'True'">
									Off The Board
								</xsl:if>
								<xsl:if test="@OffBoard = 'False'">
									Open Game
								</xsl:if>
							</td>
							<td colspan="3" style="padding-left:20px;text-align:left;border-top:solid 1px #000;">
								Follow Line
								<INPUT id="chk_FollowSpPoints_{@IdGame}_{@TeamNumber}" type="checkbox" name="chk_FollowSpPoints_{@IdGame}_{@TeamNumber}" value="{@FollowSpreadPoints}" onclick="ChangeHD('chk_FollowSpPoints_' + {@IdGame} + '_' + {@TeamNumber});">
									<xsl:if test="@FollowSpreadPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td align="right" style="border-top:solid 1px #000;">
								<INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetLine({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
						</tr>

					</table>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="//xml/@Sport = 'PROP'">
				<xsl:for-each select="GameValues">
					<table cellspacing="1" cellpadding="1" border="0" width="85%" style="border:solid 1px #000;">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
								<xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="@GameDescription != '' ">
							<tr class="TRTitle">
								<td colspan="6" align="center">
									<xsl:value-of select="@GameDescription"/>
								</td>
							</tr>
						</xsl:if>
						<tr class="TRTitle">
							<td style="width:17%;border-bottom:solid 1px #000;">CutOff</td>
							<td style="width:4%;border-bottom:solid 1px #000;">#</td>
							<td style="width:20%;border-bottom:solid 1px #000;">Prop Type</td>
							<td style="width:20%;border-bottom:solid 1px #000;">Description</td>
							<td style="width:20%;border-bottom:solid 1px #000;">Odds</td>
							<td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
						</tr>

						<tr>

							<td>
								<xsl:value-of select="@GameDateTime"/>
							</td>
							<td>
								<xsl:value-of select="@TeamNumber"/>
							</td>
							<td>
								<xsl:value-of select="@VisitorTeam"/>
							</td>
							<td>
								<xsl:value-of select="@HomeTeam"/>
							</td>
							<xsl:if test="@HideGame = 'False'">
								<td>
									<xsl:if test="@HideGame = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@Odds"/>
													<xsl:if test="@AgOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_odds_{@IdGame}_4_{@TeamNumber}" name="txt_odds_{@IdGame}_4_{@TeamNumber}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_odds_' + {@IdGame}  + '_4_' + {@TeamNumber}, '{@Odds}', '{@AgOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
							</xsl:if>
							<xsl:if test="@HideGame = 'True'">
								<td></td>
							</xsl:if>
							<td>
								<table cellspacing="0" cellpadding="0" border="0">
									<tr>
										<td align="right">
											Game
											<INPUT id="chk_HideGame_{@IdGame}_{@TeamNumber}" type="checkbox" name="chk_HideGame_{@IdGame}_{@TeamNumber}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame} + '_' +{@TeamNumber});">
												<xsl:if test="@HideGame = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr class="FollowLine">
							<td colspan="2" style="border-top:solid 1px #000;">
								<xsl:if test="@OffBoard = 'True'">
									Off The Board
								</xsl:if>
								<xsl:if test="@OffBoard = 'False'">
									Open Game
								</xsl:if>
							</td>
							<td colspan="3" style="text-align:left;">
								Follow Line
								<INPUT id="chk_FollowSpPoints_{@IdGame}_{@TeamNumber}" type="checkbox" name="chk_FollowSpPoints_{@IdGame}_{@TeamNumber}" value="{@FollowSpreadPoints}" onclick="ChangeHD('chk_FollowSpPoints_' + {@IdGame} + '_' + {@TeamNumber});">
									<xsl:if test="@FollowSpreadPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td align="right" style="border-top:solid 1px #000;">
								<INPUT id="Reset_{@IdGame}_{@TeamNumber}" type="button" class="btReset" name="Reset_{@IdGame}_{@TeamNumber}" value="Re-Set Line" onclick="ResetLine({@IdGame} + '_' + '{//xml/@Sport}' + '_' + {@TeamNumber})" />
							</td>
						</tr>
					</table>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="//xml/@Sport = 'ESOC'">
				<table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
					<tr>
						<td align="right">
							<SELECT NAME="cmbLine"  OnChange="post();">
								<OPTION VALUE="False">
									<xsl:if test="@AmericanLine='False'">
										<xsl:attribute name="Selected">Selected</xsl:attribute>
									</xsl:if>
									Decimal Line
								</OPTION>
								<OPTION VALUE="True">
									<xsl:if test="@AmericanLine='True'">
										<xsl:attribute name="Selected">Selected</xsl:attribute>
									</xsl:if>
									American Line
								</OPTION>
							</SELECT>
						</td>
					</tr>
				</table>
				<xsl:for-each select="GameValues">
					<table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
								<xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:if test="@GameDescription != '' ">
							<tr class="TRTitle">
								<td colspan="7" align="center">
									<xsl:value-of select="@GameDescription"/>
								</td>
							</tr>
						</xsl:if>
						<tr class="TRTitle">
							<td style="width:17%;border-bottom:solid 1px #000;">D/T</td>
							<td style="width:6%;border-bottom:solid 1px #000;">#</td>
							<td style="width:25%;border-bottom:solid 1px #000;">Teams</td>
							<td style="width:15%;border-bottom:solid 1px #000;">Home</td>
							<td style="width:15%;border-bottom:solid 1px #000;">Draw</td>
							<td style="width:15%;border-bottom:solid 1px #000;">Visitor</td>
							<td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
						</tr>

						<tr>

							<td>
								<xsl:value-of select="@GameDateTime"/>
							</td>
							<td>
								<xsl:value-of select="@VisitorNumber"/>
							</td>
							<td>
								<xsl:value-of select="@HomeTeam"/>-<xsl:value-of select="@VisitorTeam"/>
							</td>
							<xsl:if test="@HideGame = 'False'">
								<td>
									<xsl:if test="@HideGame = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td>
													<xsl:value-of select="@HomeOdds"/>
													<xsl:if test="@AgHomeOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgHomeOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_hod_{@IdGame}_3" name="txt_hod_{@IdGame}_3" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_3', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideGame = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorSpecialOdds"/>
													<xsl:if test="@AgVisitorSpecialOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorSpecialOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_vss_{@IdGame}_6" name="txt_vss_{@IdGame}_6" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vss_' + {@IdGame}  + '_6', '{@VisitorSpecialOdds}', '{@AgVisitorSpecialOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
								<td>
									<xsl:if test="@HideGame = 'False'">
										<table cellspacing="0" cellpadding="0" border="0" style="table-layout:inherit;">
											<tr>
												<td style="width:70%;">
													<xsl:value-of select="@VisitorOdds"/>
													<xsl:if test="@AgVisitorOdds != ''">
														[<font class="AgScheduleColor">
															<xsl:value-of select="@AgVisitorOdds"/>
														</font>]
													</xsl:if>
												</td>
												<td>
													
													
														<input type="text" id="txt_vod_{@IdGame}_9" name="txt_vod_{@IdGame}_9" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_9', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
													
												</td>
											</tr>
										</table>
									</xsl:if>
								</td>
							</xsl:if>
							<xsl:if test="@HideGame = 'True'">
								<td></td>
								<td></td>
								<td></td>
							</xsl:if>
							<td>
								<table cellspacing="0" cellpadding="0" border="0">
									<tr>
										<td align="right">
											Game
											<INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
												<xsl:if test="@HideGame = 'True'">
													<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
												</xsl:if>
											</INPUT>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr class="FollowLine">
							<td colspan="2" style="border-top:solid 1px #000;">
								<xsl:if test="@OffBoard = 'True'">
									Off The Board
								</xsl:if>
								<xsl:if test="@OffBoard = 'False'">
									Open Game
								</xsl:if>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								Follow: Spread Points
								<INPUT id="chk_FollowSpPoints_{@IdGame}" type="checkbox" name="chk_FollowSpPoints_{@IdGame}" value="{@FollowSpreadPoints}" onclick="ChangeHD('chk_FollowSpPoints_' + {@IdGame});">
									<xsl:if test="@FollowSpreadPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
								<xsl:text>  </xsl:text>
								<br/>Spread Odds
								<INPUT id="chk_FollowSpOdds_{@IdGame}" type="checkbox" name="chk_FollowSpOdds_{@IdGame}" value="{@FollowSpreadOdds}" onclick="ChangeHD('chk_FollowSpOdds_' + {@IdGame});">
									<xsl:if test="@FollowSpreadOdds = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								$Line
								<INPUT id="chk_FollowMl_{@IdGame}" type="checkbox" name="chk_FollowMl_{@IdGame}" value="{@FollowMoney}" onclick="ChangeHD('chk_FollowMl_' + {@IdGame});">
									<xsl:if test="@FollowMoney = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td style="text-align:center;border-top:solid 1px #000;border-right:none;">
								Total Points
								<INPUT id="chk_FollowTtPoints_{@IdGame}" type="checkbox" name="chk_FollowTtPoints_{@IdGame}" value="{@FollowTotalPoints}" onclick="ChangeHD('chk_FollowTtPoints_' + {@IdGame});">
									<xsl:if test="@FollowTotalPoints = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
								<xsl:text>  </xsl:text>
								<br/>Total Odds
								<INPUT id="chk_FollowTtOdds_{@IdGame}" type="checkbox" name="chk_FollowTtOdds_{@IdGame}" value="{@FollowTotalOdds}" onclick="ChangeHD('chk_FollowTtOdds_' + {@IdGame});">
									<xsl:if test="@FollowTotalOdds = 'True'">
										<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
									</xsl:if>
								</INPUT>
							</td>
							<td align="Right" style="border-top:solid 1px #000;">
								<INPUT type="button" class="btReset" id="Event_{@IdGame}" name="Event_{@IdGame}" value="Events" onclick="GetGameEventDetail({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
							<td align="right" style="border-top:solid 1px #000;">
								<INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetLine({@IdGame} + '_' + '{//xml/@Sport}')" />
							</td>
						</tr>
					</table>
				</xsl:for-each>
			</xsl:if>

			


		</center>

		<div class="sticky-footer text-center py-2 bg-dark border-top">
			<div class="d-inline-flex gap-2">

				<input type="button" value="Close"
					   class="btn btn-sm btn-danger fw-bold shadow-sm px-4"
					   onclick="window.location.href='/Report/Welcome.aspx';" />

				<input type="button" class="btn btn-sm btn-primary fw-bold shadow-sm px-4"
									   value="Refresh"
									   onclick="window.location.href='AgentLineMover.aspx?Sport=' + '{//xml/@Sport}'" />

				<xsl:choose>
					<xsl:when test="count(GameValues) > 0">
						<input type="submit"
							   value="Save"
							   class="btn btn-sm btn-success fw-bold shadow-sm px-4"
							   onclick="return goToLastAfterSave(this.form);" />
					</xsl:when>

					<xsl:otherwise>
						<input type="submit"
							   value="Submit"
							   class="btn btn-sm btn-secondary fw-bold shadow-sm px-4" />
					</xsl:otherwise>
				</xsl:choose>

			</div>
		</div>

	</xsl:template>


</xsl:stylesheet>
