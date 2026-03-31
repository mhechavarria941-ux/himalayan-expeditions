-- Data Dictionary Population Script - COMPLETE AND ACCURATE
-- Purpose: Populate himalayan_data_dictionary table with all 21 tables
-- Date: March 30, 2026
-- Updated: Complete normalized schema with all tables

-- Ensure table exists and is cleared
IF OBJECT_ID('himalayan_data_dictionary', 'U') IS NOT NULL
BEGIN
    TRUNCATE TABLE himalayan_data_dictionary;
END;
GO

-- Insert data dictionary entries for ALL 21 tables
INSERT INTO dbo.himalayan_data_dictionary (Column1, Column2, Column3)
VALUES

-- =========================================================
-- peaks
-- =========================================================
('peaks', NULL, 'Peak master table. One row represents one mountain or peak.'),
('peaks', 'peakid', 'Primary key of the peaks table. Unique identifier for each peak.'),
('peaks', 'pkname', 'Primary peak name.'),
('peaks', 'pkname2', 'Alternate peak name.'),
('peaks', 'location', 'Location description of the peak.'),
('peaks', 'heightm', 'Peak height in meters.'),
('peaks', 'heightf', 'Peak height in feet.'),
('peaks', 'himal', 'Himalayan range grouping or region family.'),
('peaks', 'region', 'Regional classification of the peak.'),
('peaks', 'open', 'Indicates whether the peak is open to expeditions.'),
('peaks', 'unlisted', 'Indicates whether the peak is unlisted or unofficial in some contexts.'),
('peaks', 'trekking', 'Indicates trekking peak status.'),
('peaks', 'trekyear', 'Year related to trekking peak designation.'),
('peaks', 'restrict', 'Restriction information for the peak.'),
('peaks', 'phost', 'Host or administrative ownership information related to the peak.'),
('peaks', 'pstatus', 'Status of the peak in the original dataset.'),
('peaks', 'pyear', 'Peak-related year field from the original dataset.'),
('peaks', 'pseason', 'Peak-related season field from the original dataset.'),
('peaks', 'pmonth', 'Peak-related month field from the original dataset.'),
('peaks', 'pday', 'Peak-related day field from the original dataset.'),
('peaks', 'pexpid', 'Peak-related expedition identifier from the original dataset.'),
('peaks', 'pcountry', 'Country associated with the peak.'),
('peaks', 'psummiters', 'Number of summiteers associated with the peak-related record.'),
('peaks', 'psmtnote', 'Peak-related summit note or comments.'),

-- =========================================================
-- season_lookup
-- =========================================================
('season_lookup', NULL, 'Lookup table for expedition seasons. One row represents one standardized season category.'),
('season_lookup', 'SeasonKey', 'Primary key of season_lookup. Surrogate identifier for a season category.'),
('season_lookup', 'SeasonName', 'Standardized season value such as Spring, Summer, Autumn, or Winter.'),

-- =========================================================
-- citizenship_lookup
-- =========================================================
('citizenship_lookup', NULL, 'Lookup table for member citizenship categories. One row represents one standardized citizenship value.'),
('citizenship_lookup', 'CitizenshipKey', 'Primary key of citizenship_lookup. Surrogate identifier for a citizenship category.'),
('citizenship_lookup', 'CitizenshipName', 'Standardized citizenship value used to classify member origin.'),

-- =========================================================
-- exped (CORE - MODIFIED)
-- =========================================================
('exped', NULL, 'Core expedition table. One row represents one expedition. This is the central parent entity in the normalized schema.'),
('exped', 'ExpeditionKey', 'Primary key of the expedition table. Surrogate identifier assigned to each expedition row.'),
('exped', 'expid', 'Source expedition identifier from the original dataset. Used with year as the business-level unique identifier.'),
('exped', 'year', 'Expedition year. Used with expid to distinguish expeditions whose source identifier repeats across years.'),
('exped', 'peakid', 'Foreign key to peaks. Identifies the peak associated with the expedition.'),
('exped', 'SeasonKey', 'Foreign key to season_lookup. Standardized season classification of the expedition.'),
('exped', 'host', 'Host country or administrative context of the expedition.'),
('exped', 'nation', 'Expedition national affiliation or sponsoring nation.'),
('exped', 'leaders', 'Leader or leaders of the expedition.'),
('exped', 'sponsor', 'Sponsor information for the expedition.'),
('exped', 'approach', 'Approach route or access description for the expedition.'),

-- =========================================================
-- members (CORE - MODIFIED)
-- =========================================================
('members', NULL, 'Member participation table. One row represents one member participation record associated with one expedition.'),
('members', 'MemberKey', 'Primary key of the members table. Surrogate identifier assigned to each member participation row.'),
('members', 'ExpeditionKey', 'Foreign key to exped. Links the member record to its parent expedition.'),
('members', 'CitizenshipKey', 'Foreign key to citizenship_lookup. Standardized citizenship classification for the member.'),
('members', 'membid', 'Source member identifier from the original dataset. Not used alone as the final primary key.'),
('members', 'expid', 'Source expedition identifier carried in the member record. Retained for traceability and source reference.'),
('members', 'peakid', 'Peak identifier carried in the source member record.'),
('members', 'myear', 'Member record year from the original dataset. Used in business-key analysis of member participation identity.'),
('members', 'mseason', 'Member-related season field from the original dataset.'),
('members', 'fname', 'Member first name.'),
('members', 'lname', 'Member last name.'),
('members', 'sex', 'Member sex or gender field.'),
('members', 'yob', 'Year of birth of the member.'),
('members', 'status', 'Status of the member in the original dataset.'),
('members', 'residence', 'Residence of the member.'),
('members', 'occupation', 'Occupation of the member.'),
('members', 'leader', 'Indicates whether the member was a leader.'),
('members', 'deputy', 'Indicates whether the member was a deputy leader.'),
('members', 'bconly', 'Indicates whether the member reached base camp only.'),
('members', 'nottobc', 'Indicates whether the member did not go to base camp.'),
('members', 'support', 'Indicates support role.'),
('members', 'disabled', 'Indicates disability-related field from the source dataset.'),
('members', 'hired', 'Indicates whether the member was hired staff.'),
('members', 'sherpa', 'Indicates whether the member was a Sherpa.'),
('members', 'tibetan', 'Indicates whether the member was Tibetan.'),
('members', 'msuccess', 'Member summit success indicator.'),
('members', 'mclaimed', 'Member-level claimed success field.'),
('members', 'mdisputed', 'Member-level disputed success field.'),
('members', 'msolo', 'Indicates whether the member climbed solo.'),
('members', 'mtraverse', 'Indicates whether the member completed a traverse.'),
('members', 'mski', 'Indicates whether the member used skiing in the expedition context.'),
('members', 'mparapente', 'Indicates whether the member used parapente/paragliding.'),
('members', 'mspeed', 'Indicates speed-related ascent field.'),
('members', 'mhighpt', 'Highest point reached by the member.'),
('members', 'mperhighpt', 'Member performance or percent-highpoint related field from the source dataset.'),
('members', 'msmtdate1', 'Member summit date field 1.'),
('members', 'msmtdate2', 'Member summit date field 2.'),
('members', 'msmtdate3', 'Member summit date field 3.'),
('members', 'msmttime1', 'Member summit time field 1.'),
('members', 'msmttime2', 'Member summit time field 2.'),
('members', 'msmttime3', 'Member summit time field 3.'),
('members', 'mroute1', 'Member route field 1.'),
('members', 'mroute2', 'Member route field 2.'),
('members', 'mroute3', 'Member route field 3.'),
('members', 'mascent1', 'Member ascent field 1.'),
('members', 'mascent2', 'Member ascent field 2.'),
('members', 'mascent3', 'Member ascent field 3.'),
('members', 'mo2used', 'Member oxygen-used field.'),
('members', 'mo2none', 'Member no-oxygen field.'),
('members', 'mo2climb', 'Member oxygen-on-climb field.'),
('members', 'mo2descent', 'Member oxygen-on-descent field.'),
('members', 'mo2sleep', 'Member oxygen-during-sleep field.'),
('members', 'mo2medical', 'Member oxygen-for-medical-use field.'),
('members', 'mo2note', 'Member oxygen notes.'),
('members', 'death', 'Indicates whether the member died.'),
('members', 'deathdate', 'Date of member death.'),
('members', 'deathtime', 'Time of member death.'),
('members', 'deathtype', 'Type/category of death.'),
('members', 'deathhgtm', 'Height in meters at which death occurred.'),
('members', 'deathclass', 'Classification of member death.'),
('members', 'msmtbid', 'Member summit bid identifier or related field from the source dataset.'),
('members', 'msmtterm', 'Member summit termination or related narrative field.'),
('members', 'hcn', 'Source field from the original dataset retained for traceability.'),
('members', 'mchksum', 'Checksum or source control field for the member record.'),

-- =========================================================
-- refer (CORE - MODIFIED)
-- =========================================================
('refer', NULL, 'Reference table. One row represents one bibliographic or reference record associated with one expedition.'),
('refer', 'ReferenceKey', 'Primary key of the refer table. Surrogate identifier assigned to each reference record.'),
('refer', 'ExpeditionKey', 'Foreign key to exped. Links the reference record to its parent expedition.'),
('refer', 'refid', 'Source reference identifier from the original dataset.'),
('refer', 'expid', 'Source expedition identifier recorded in the reference table.'),
('refer', 'ryear', 'Reference year from the original dataset.'),
('refer', 'rtype', 'Reference type or classification.'),
('refer', 'rjrnl', 'Reference journal or publication outlet.'),
('refer', 'rauthor', 'Reference author or authors.'),
('refer', 'rtitle', 'Reference title.'),
('refer', 'rpublisher', 'Reference publisher information.'),
('refer', 'rpubdate', 'Reference publication date.'),
('refer', 'rlanguage', 'Reference language.'),
('refer', 'rcitation', 'Full reference citation text.'),
('refer', 'ryak94', 'Source-specific reference field retained from the original dataset.'),

-- =========================================================
-- expedition_timeline
-- =========================================================
('expedition_timeline', NULL, 'Child table of exped containing expedition chronology, dates, duration, and termination details.'),
('expedition_timeline', 'ExpeditionTimelineKey', 'Primary key of expedition_timeline.'),
('expedition_timeline', 'ExpeditionKey', 'Foreign key to exped. Links the timeline record to its expedition.'),
('expedition_timeline', 'bcdate', 'Base camp date.'),
('expedition_timeline', 'smtdate', 'Summit date.'),
('expedition_timeline', 'smttime', 'Summit time.'),
('expedition_timeline', 'smtdays', 'Number of days to summit.'),
('expedition_timeline', 'totdays', 'Total duration of the expedition in days.'),
('expedition_timeline', 'termdate', 'Expedition termination date.'),
('expedition_timeline', 'termreason', 'Reason for expedition termination.'),
('expedition_timeline', 'termnote', 'Additional termination notes.'),

-- =========================================================
-- expedition_routes
-- =========================================================
('expedition_routes', NULL, 'Child table of exped containing normalized expedition route entries. One row represents one route associated with one expedition.'),
('expedition_routes', 'ExpeditionRouteKey', 'Primary key of expedition_routes.'),
('expedition_routes', 'ExpeditionKey', 'Foreign key to exped. Links the route entry to its expedition.'),
('expedition_routes', 'RouteNumber', 'Sequence number indicating which original route field the row came from.'),
('expedition_routes', 'RouteDescription', 'Route description associated with the expedition.'),

-- =========================================================
-- expedition_outcomes
-- =========================================================
('expedition_outcomes', NULL, 'Child table of exped containing normalized outcome and ascent entries. One row represents one outcome entry for one expedition.'),
('expedition_outcomes', 'ExpeditionOutcomeKey', 'Primary key of expedition_outcomes.'),
('expedition_outcomes', 'ExpeditionKey', 'Foreign key to exped. Links the outcome row to its expedition.'),
('expedition_outcomes', 'OutcomeNumber', 'Sequence number indicating which original success/ascent pair the row came from.'),
('expedition_outcomes', 'SuccessStatus', 'Outcome success value from the original expedition record.'),
('expedition_outcomes', 'AscentDescription', 'Outcome ascent description from the original expedition record.'),

-- =========================================================
-- expedition_statistics
-- =========================================================
('expedition_statistics', NULL, 'Child table of exped containing quantitative expedition statistics and measurable counts.'),
('expedition_statistics', 'ExpeditionStatisticsKey', 'Primary key of expedition_statistics.'),
('expedition_statistics', 'ExpeditionKey', 'Foreign key to exped. Links the statistics record to its expedition.'),
('expedition_statistics', 'totmembers', 'Total number of expedition members.'),
('expedition_statistics', 'smtmembers', 'Number of members who summited.'),
('expedition_statistics', 'mdeaths', 'Number of member deaths.'),
('expedition_statistics', 'tothired', 'Total hired personnel.'),
('expedition_statistics', 'smthired', 'Number of hired personnel who summited.'),
('expedition_statistics', 'hdeaths', 'Number of hired personnel deaths.'),
('expedition_statistics', 'nohired', 'Field related to non-hired participation from the original dataset.'),
('expedition_statistics', 'highpoint', 'Highest point reached by the expedition.'),

-- =========================================================
-- expedition_style
-- =========================================================
('expedition_style', NULL, 'Child table of exped containing expedition style and classification flags.'),
('expedition_style', 'ExpeditionStyleKey', 'Primary key of expedition_style.'),
('expedition_style', 'ExpeditionKey', 'Foreign key to exped. Links the style record to its expedition.'),
('expedition_style', 'claimed', 'Indicates whether summit success was claimed.'),
('expedition_style', 'disputed', 'Indicates whether summit success was disputed.'),
('expedition_style', 'traverse', 'Indicates whether the expedition involved a traverse.'),
('expedition_style', 'ski', 'Indicates whether the expedition involved skiing.'),
('expedition_style', 'parapente', 'Indicates whether the expedition involved parapente/paragliding.'),

-- =========================================================
-- expedition_oxygen
-- =========================================================
('expedition_oxygen', NULL, 'Child table of exped containing expedition-level oxygen usage information.'),
('expedition_oxygen', 'ExpeditionOxygenKey', 'Primary key of expedition_oxygen.'),
('expedition_oxygen', 'ExpeditionKey', 'Foreign key to exped. Links the oxygen record to its expedition.'),
('expedition_oxygen', 'o2used', 'Indicates whether oxygen was used.'),
('expedition_oxygen', 'o2none', 'Indicates whether no oxygen was used.'),
('expedition_oxygen', 'o2climb', 'Indicates whether oxygen was used during climbing.'),
('expedition_oxygen', 'o2descent', 'Indicates whether oxygen was used during descent.'),
('expedition_oxygen', 'o2sleep', 'Indicates whether oxygen was used while sleeping.'),
('expedition_oxygen', 'o2medical', 'Indicates whether oxygen was used for medical purposes.'),
('expedition_oxygen', 'o2taken', 'Indicates whether oxygen was carried or taken.'),
('expedition_oxygen', 'o2unkwn', 'Indicates whether oxygen usage is unknown.'),

-- =========================================================
-- expedition_camps
-- =========================================================
('expedition_camps', NULL, 'Child table of exped containing camp and campsite information.'),
('expedition_camps', 'ExpeditionCampsKey', 'Primary key of expedition_camps.'),
('expedition_camps', 'ExpeditionKey', 'Foreign key to exped. Links the camps record to its expedition.'),
('expedition_camps', 'camps', 'Camp information from the original expedition record.'),
('expedition_camps', 'campsites', 'Campsite details from the original expedition record.'),

-- =========================================================
-- expedition_incidents
-- =========================================================
('expedition_incidents', NULL, 'Child table of exped containing incident, accident, and achievement narratives.'),
('expedition_incidents', 'ExpeditionIncidentsKey', 'Primary key of expedition_incidents.'),
('expedition_incidents', 'ExpeditionKey', 'Foreign key to exped. Links the incidents record to its expedition.'),
('expedition_incidents', 'accidents', 'Accident or incident information associated with the expedition.'),
('expedition_incidents', 'achievment', 'Achievement narrative associated with the expedition.'),

-- =========================================================
-- expedition_reference_summary
-- =========================================================
('expedition_reference_summary', NULL, 'Child table of exped containing expedition route/reference summary metadata.'),
('expedition_reference_summary', 'ExpeditionReferenceSummaryKey', 'Primary key of expedition_reference_summary.'),
('expedition_reference_summary', 'ExpeditionKey', 'Foreign key to exped. Links the reference summary record to its expedition.'),
('expedition_reference_summary', 'comrte', 'Commercial route field retained from the original expedition record.'),
('expedition_reference_summary', 'stdrte', 'Standard route field retained from the original expedition record.'),
('expedition_reference_summary', 'primrte', 'Primary route field retained from the original expedition record.'),
('expedition_reference_summary', 'primmem', 'Primary member-related field retained from the original expedition record.'),
('expedition_reference_summary', 'primref', 'Primary reference-related field retained from the original expedition record.'),
('expedition_reference_summary', 'primid', 'Primary identifier/reference summary field retained from the original expedition record.'),

-- =========================================================
-- expedition_admin
-- =========================================================
('expedition_admin', NULL, 'Child table of exped containing administrative or support metadata.'),
('expedition_admin', 'ExpeditionAdminKey', 'Primary key of expedition_admin.'),
('expedition_admin', 'ExpeditionKey', 'Foreign key to exped. Links the admin record to its expedition.'),
('expedition_admin', 'agency', 'Agency associated with the expedition.'),
('expedition_admin', 'othersmts', 'Other summits field retained from the original expedition record.'),
('expedition_admin', 'chksum', 'Checksum or administrative control field retained from the original expedition record.'),

-- =========================================================
-- member_person
-- =========================================================
('member_person', NULL, 'Person master table. One row represents one unique individual across all expeditions.'),
('member_person', 'PersonKey', 'Primary key of member_person. Surrogate identifier for each individual.'),
('member_person', 'membid', 'Business identifier from the original dataset representing the individual.'),
('member_person', 'CitizenshipKey', 'Foreign key to citizenship_lookup. Standardized citizenship classification.'),
('member_person', 'fname', 'First name of the individual.'),
('member_person', 'lname', 'Last name of the individual.'),
('member_person', 'sex', 'Sex or gender of the individual.'),
('member_person', 'yob', 'Year of birth.'),
('member_person', 'residence', 'Place of residence.'),
('member_person', 'occupation', 'Occupation of the individual.'),
('member_person', 'hcn', 'Source field retained for traceability.'),

-- =========================================================
-- member_participation
-- =========================================================
('member_participation', NULL, 'Participation table. One row represents one individual participating in one expedition.'),
('member_participation', 'MemberParticipationKey', 'Primary key of member_participation. Surrogate identifier for each participation record.'),
('member_participation', 'LegacyMemberKey', 'Original MemberKey from dbo.members retained for traceability.'),
('member_participation', 'PersonKey', 'Foreign key to member_person. Identifies the individual.'),
('member_participation', 'ExpeditionKey', 'Foreign key to exped. Links participation to an expedition.'),
('member_participation', 'expid', 'Original expedition identifier from source data.'),
('member_participation', 'peakid', 'Foreign key to peaks. Identifies the associated peak.'),
('member_participation', 'myear', 'Year of participation from the original dataset.'),
('member_participation', 'mseason', 'Season of participation.'),
('member_participation', 'status', 'Status of the participant.'),
('member_participation', 'leader', 'Indicates leadership role.'),
('member_participation', 'deputy', 'Indicates deputy leadership role.'),
('member_participation', 'bconly', 'Indicates base-camp-only participation.'),
('member_participation', 'nottobc', 'Indicates no base camp participation.'),
('member_participation', 'support', 'Indicates support role.'),
('member_participation', 'disabled', 'Indicates disability-related field.'),
('member_participation', 'hired', 'Indicates hired staff.'),
('member_participation', 'sherpa', 'Indicates Sherpa role.'),
('member_participation', 'tibetan', 'Indicates Tibetan role.'),
('member_participation', 'msuccess', 'Indicates summit success.'),
('member_participation', 'mclaimed', 'Indicates claimed success.'),
('member_participation', 'mdisputed', 'Indicates disputed success.'),
('member_participation', 'msolo', 'Indicates solo climb.'),
('member_participation', 'mtraverse', 'Indicates traverse.'),
('member_participation', 'mski', 'Indicates ski usage.'),
('member_participation', 'mparapente', 'Indicates parapente usage.'),
('member_participation', 'mspeed', 'Speed-related attribute.'),
('member_participation', 'mhighpt', 'Highest point reached.'),
('member_participation', 'mperhighpt', 'Performance metric related to high point.'),
('member_participation', 'mo2used', 'Indicates oxygen usage.'),
('member_participation', 'mo2none', 'Indicates no oxygen usage.'),
('member_participation', 'mo2climb', 'Oxygen used during climb.'),
('member_participation', 'mo2descent', 'Oxygen used during descent.'),
('member_participation', 'mo2sleep', 'Oxygen used during sleep.'),
('member_participation', 'mo2medical', 'Oxygen used for medical purposes.'),
('member_participation', 'mo2note', 'Oxygen-related notes.'),
('member_participation', 'death', 'Indicates death occurrence.'),
('member_participation', 'deathdate', 'Date of death.'),
('member_participation', 'deathtime', 'Time of death.'),
('member_participation', 'deathtype', 'Type of death.'),
('member_participation', 'deathhgtm', 'Height at which death occurred.'),
('member_participation', 'deathclass', 'Classification of death.'),
('member_participation', 'msmtbid', 'Summit bid identifier.'),
('member_participation', 'msmtterm', 'Summit termination notes.'),
('member_participation', 'mchksum', 'Checksum field for traceability.'),

-- =========================================================
-- member_routes
-- =========================================================
('member_routes', NULL, 'Child table of member_participation. One row represents one route taken by a participant.'),
('member_routes', 'MemberRouteKey', 'Primary key of member_routes.'),
('member_routes', 'MemberParticipationKey', 'Foreign key to member_participation.'),
('member_routes', 'RouteNumber', 'Sequence number of the route.'),
('member_routes', 'RouteDescription', 'Route description.'),

-- =========================================================
-- member_summits
-- =========================================================
('member_summits', NULL, 'Child table of member_participation. One row represents one summit attempt or record.'),
('member_summits', 'MemberSummitKey', 'Primary key of member_summits.'),
('member_summits', 'MemberParticipationKey', 'Foreign key to member_participation.'),
('member_summits', 'SummitNumber', 'Sequence number of the summit entry.'),
('member_summits', 'SummitDate', 'Date of summit attempt.'),
('member_summits', 'SummitTime', 'Time of summit attempt.'),
('member_summits', 'AscentDescription', 'Description of ascent.'),

-- =========================================================
-- audit_deleted_references
-- =========================================================
('audit_deleted_references', NULL, 'Audit table for deleted reference records. Documents orphan records removed during data cleaning.'),
('audit_deleted_references', 'AuditID', 'Primary key of audit_deleted_references.'),
('audit_deleted_references', 'ReferenceKey', 'Reference key of deleted record.'),
('audit_deleted_references', 'refid', 'Reference ID of deleted record.'),
('audit_deleted_references', 'expid', 'Expedition ID of deleted record.'),
('audit_deleted_references', 'ryear', 'Reference year of deleted record.'),
('audit_deleted_references', 'rtype', 'Reference type of deleted record.'),
('audit_deleted_references', 'rtitle', 'Reference title of deleted record.'),
('audit_deleted_references', 'DeletedDate', 'Date and time when record was deleted.'),
('audit_deleted_references', 'DeleteReason', 'Reason for deletion.');

PRINT 'Data dictionary populated successfully with all 21 tables.';
GO
