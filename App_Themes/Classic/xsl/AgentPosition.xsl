<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output  method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">
		<div class="row">
			<div class="page-titles">
				<h4>Agent Position</h4>
			</div>
		</div>

		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<div class="row">

							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date1">Initial Date:</label>
									<br></br>
									<INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{//xml/@StartDate}" />
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date2">End Date:</label>
									<br></br>
									<INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date2" value="{//xml/@EndDate}" />
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date2">Show With Futures:</label>
									<br></br>
									<INPUT id="ckShowFutures" type="checkbox" name="ckShowFutures" values="{@ShowFutures}">
										<xsl:if test="@ShowFutures = 'True'">
											<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
										</xsl:if>
									</INPUT>
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:24px;" value="Submit" name="Submit" />
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>			
		</div>


					<center>
						<h4 class="card-title">
							From <xsl:value-of select="//xml/@StartDate"/> To <xsl:value-of select="//xml/@EndDate"/>
						</h4>
					</center>
				

		
		<div class="table-responsive">
			<TABLE class="table-dynamic table table-bordered table-striped  d-none d-lg-table">
				<xsl:for-each select="game">
					<xsl:variable name="sport">
						<xsl:value-of select="@IdSport"/>
					</xsl:variable>
					<THEAD>
						<TR>
							<th>
								<xsl:value-of select="@GameDateTime"/>
							</th>
							<th>
								<xsl:value-of select="@Title2"/>
							</th>
							<th>
								<xsl:value-of select="@Title3"/>
							</th>
							<th>
								<xsl:value-of select="@Title4"/>
							</th>
							<th>
								<xsl:value-of select="@Title5"/>
							</th>
							<th>
								<xsl:value-of select="@Title6"/>
							</th>
							<th>
								<xsl:value-of select="@Title7"/>
							</th>
							<!--<th>
												<xsl:value-of select="@Title8"/>
											</th>
											<th>
												<xsl:value-of select="@Title9"/>
											</th>-->
						</TR>
					</THEAD>
					<xsl:for-each select="detail">
						<TR>
							<td>
								<a href="javascript:GetPositionDetail('{//@IdGame}_{//xml/@StartDate}_{//xml/@EndDate}');" >
									<xsl:value-of disable-output-escaping="yes"  select="@Title1"/>
								</a>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title2"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title3"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title4"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title5"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title6"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title7"/>
							</td>
							<!--<td>
												<xsl:value-of disable-output-escaping="yes" select="@Title8"/>
											</td>
											<td>
												<xsl:value-of disable-output-escaping="yes" select="@Title9"/>
											</td>-->

							<!--<xsl:for-each select="@*">
                      <TD>
                        <xsl:value-of disable-output-escaping="yes" select="."/>
                      </TD>
                    </xsl:for-each>-->
						</TR>
					</xsl:for-each>
				</xsl:for-each>
			</TABLE>

			<TABLE class="table-dynamic table table-bordered table-striped d-lg-none">
				<xsl:for-each select="game">
					<xsl:variable name="sport">
						<xsl:value-of select="@IdSport"/>
					</xsl:variable>
					<xsl:variable name="Title2">
						<xsl:value-of select="@Title2"/>
					</xsl:variable>
					<xsl:variable name="Title4">
						<xsl:value-of select="@Title4"/>
					</xsl:variable>
					<xsl:variable name="Title6">
						<xsl:value-of select="@Title6"/>
					</xsl:variable>
					<xsl:variable name="Title8">
						<xsl:value-of select="@Title8"/>
					</xsl:variable>
					<THEAD>
						<TR>
							<th>
								<xsl:value-of select="@GameDateTime"/>
							</th>
							<th colspan="2">
								<!--<xsl:value-of select="@Title2"/>-->
							</th>
							<th>
								<xsl:value-of select="@Title3"/>
							</th>
						</TR>
					</THEAD>
					<xsl:for-each select="detail">
						<TR>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="count(preceding::detail) mod 2 = 0">TrGameOdd</xsl:when>
									<xsl:otherwise>TrGameEven</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<td>
								<xsl:attribute name="rowspan">
									<xsl:choose>
										<xsl:when test="$sport = 'NHL'">4</xsl:when>
										<xsl:otherwise>3</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<a href="javascript:GetPositionDetail('{//@IdGame}_{//xml/@StartDate}_{//xml/@EndDate}');" >
									<xsl:value-of disable-output-escaping="yes"  select="@Title1"/>
								</a>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="$Title2"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title2"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title3"/>
							</td>
						</TR>
						<tr>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="count(preceding::detail) mod 2 = 0">TrGameOdd</xsl:when>
									<xsl:otherwise>TrGameEven</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="$Title4"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title4"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title5"/>
							</td>
						</tr>
						<tr>
							<xsl:attribute name="class">
								<xsl:choose>
									<xsl:when test="count(preceding::detail) mod 2 = 0">TrGameOdd</xsl:when>
									<xsl:otherwise>TrGameEven</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="$Title6"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title6"/>
							</td>
							<td>
								<xsl:value-of disable-output-escaping="yes" select="@Title7"/>
							</td>
						</tr>
						<xsl:if test="$sport = 'NHL'">
							<tr>
								<xsl:attribute name="class">
									<xsl:choose>
										<xsl:when test="count(preceding::detail) mod 2 = 0">TrGameOdd</xsl:when>
										<xsl:otherwise>TrGameEven</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<td>
									<xsl:value-of disable-output-escaping="yes" select="$Title8"/>
								</td>
								<td>
									<xsl:value-of disable-output-escaping="yes" select="@Title8"/>
								</td>
								<td>
									<xsl:value-of disable-output-escaping="yes" select="@Title9"/>
								</td>
							</tr>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</TABLE>

		</div>

	</xsl:template>

</xsl:stylesheet>
