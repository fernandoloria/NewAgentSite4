<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:asp="remove" xmlns:Localized="remove">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="no" />

	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="/*">
		<ul class="sidebar-panel nav" id="sportNav">

			<xsl:for-each select="//index">
				<xsl:variable name="newtext" select="translate(@value,' ','')"/>
				<li>
					<a href="javascript:;" class="test">
						<xsl:choose>
							<xsl:when test="(@value = 'CBB') or (@value ='COLLEGE BASKETBALL')">
								<span class="icon sport-menu basketball"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'LIVE WAGERING'">
								<span class="icon sport-menu e-sports"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(@value = 'NBA') or (@value ='BASKETBALL') or (@value ='WNBA') or (@value ='NCAA BASKETBALL - PROPS AND FUTURES') or (@value = 'BASKETBALL PROPS') or (@value = 'BASKETBALL - PROPS') or (@value = 'INTERNATIONAL BASKETBALL') or (@value = 'BASKETBALL -  PROPS AND FUTURES') or (@value = 'BASKETBALL - FUTURES')">
								<span class="icon sport-menu basketball"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'EURO LEAGUE'">
								<span class="icon sport-menu basketball"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'nfl')">
								<span class="icon sport-menu football"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(@value = 'NFL') or (@value = 'FOOTBALL') or (@value = 'AMERICAN FOOTBALL') or (@value = 'PRO FOOTBALL - PROPS AND FUTURES') or (@value = 'NFL FOOTBALL - PROPS AND FUTURES') or (@value = 'CANADIAN FOOTBALL') or (@value = 'FOOTBALL - PROPS') or (@value = 'FOOTBALL - FUTURES')">
								<span class="icon sport-menu football"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(@value = 'CFB') or (@value = 'NCAA FOOTBALL -  PROPS AND FUTURES') or (@value = 'COLLEGE FOOTBALL')">
								<span class="icon sport-menu football"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'CFL'">
								<span class="icon sport-menu football"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(@value = 'NHL') or (contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'hockey'))">
								<span class="icon sport-menu hockey"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'baseball')) or (contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'mlb'))">
								<span class="icon sport-menu baseball"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'soccer')) or (contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'uefa')) or (@value = 'COPA AMERICA')">
								<span class="icon sport-menu soccer"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'GOLF'">
								<span class="icon sport-menu golf"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'tennis')">
								<span class="icon sport-menu tennis"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'lacrosse')">
								<span class="icon sport-menu lacrosse"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'OLYMPICS'">
								<span class="icon sport-menu olympics"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'FIGHTING'">
								<span class="icon sport-menu mixed-martial-arts"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(@value = 'RUGBY') or (@value = 'AUSTRALIAN RULES') or (@value = 'RUGBY FUTURES')">
								<span class="icon sport-menu rugby-league"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(@value = 'MOTOR RACING') or (@value = 'MOTOR SPORTS') or (@value = 'FORMULA ONE')" >
								<span class="icon sport-menu motor-sport"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'CRICKET'">
								<span class="icon sport-menu cricket"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'POLITICS'">
								<span class="icon sport-menu politics"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'SPECIAL EVENTS'">
								<span class="icon sport-menu other"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="(@value = 'MARTIAL ARTS') or (@value = 'MIXED MARTIAL ARTS')">
								<span class="icon sport-menu mixed-martial-arts"></span>
								<xsl:value-of select="@value" />
							</xsl:when>
							<xsl:when test="@value = 'MU'">
								<span class="icon sport-menu entertainment"></span> SPECIAL / PROPS
							</xsl:when>

							<xsl:when test="(@value = 'AUTO RACING') or (@value = 'MOTO RACING') or (@value = 'MOTORSPORT-')">
								<span class="icon sport-menu motor-sport"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="@value = 'CYCLING'">
								<span class="icon sport-menu cycling"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="(@value = 'HORSES FUTURES') or (@value = 'HORSES')">
								<span class="icon sport-menu horse-racing"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="@value = 'DARTS'">
								<span class="icon sport-menu darts"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="@value = 'SNOOKER'">
								<span class="icon sport-menu snooker"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="@value = 'SURFING'">
								<span class="icon sport-menu surfing"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="(@value = 'E-SPORTS') or (@value = 'ESPORTS')">
								<span class="icon sport-menu esport-games"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="@value = 'POKER'">
								<span class="icon sport-menu casino"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="@value = 'BOXING'">
								<span class="icon sport-menu boxing"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="@value = 'IN HOUSE - LIVE BETTING'">
								<span class="icon sport-menu live"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:when test="@value = 'VOLLEYBALL'">
								<span class="icon sport-menu volleyball"></span>
								<xsl:value-of select="@value" />
							</xsl:when>

							<xsl:otherwise>
								<span class="icon sport-menu"></span>
								<xsl:value-of select="@value" />
							</xsl:otherwise>
						</xsl:choose>

					</a>
					<ul id="collapse-{$newtext}">
						<xsl:apply-templates select="." />
					</ul>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="league">
		<li>
			<a href="javascript:;" data-lg="{@id}" onclick="showLines(this)">
				<xsl:value-of disable-output-escaping="yes" select="@desc" />
			</a>
		</li>
	
	</xsl:template>

</xsl:stylesheet>
