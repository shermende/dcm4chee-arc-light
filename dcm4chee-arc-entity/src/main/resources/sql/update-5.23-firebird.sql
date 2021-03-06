-- part 1: can be applied on archive running archive 5.22
alter table person_name
    add alphabetic_name varchar(255),
    add ideographic_name varchar(255),
    add phonetic_name varchar(255);

update person_name
set alphabetic_name = coalesce(family_name, '') || '^' || coalesce(given_name, '') || '^' || coalesce(middle_name, '')
                        || '^' || coalesce(name_prefix, '') || '^' || coalesce(name_suffix, '') || '^',
    ideographic_name = coalesce(i_family_name, '') || '^' || coalesce(i_given_name, '') || '^' || coalesce(i_middle_name, '')
                        || '^' || coalesce(i_name_prefix, '') || '^' || coalesce(i_name_suffix, '') || '^',
    phonetic_name = coalesce(p_family_name, '') || '^' || coalesce(p_given_name, '') || '^' || coalesce(p_middle_name, '')
                        || '^' || coalesce(p_name_prefix, '') || '^' || coalesce(p_name_suffix, '') || '^';

create index UK_gs2yshbwu0gkd33yxyv13keoh on person_name (alphabetic_name);
create index UK_ala4l4egord8i2tjvjidoqd1s on person_name (ideographic_name);
create index UK_9nr8ddkp8enufvbn72esyw3n1 on person_name (phonetic_name);

create index alphabetic_name_upper_idx on person_name computed by (upper(alphabetic_name));

alter table issuer drop constraint UK_gknfxd1vh283cmbg8ymia9ms8;
create index UK_gknfxd1vh283cmbg8ymia9ms8 on issuer (entity_id);

alter table series
    add receiving_aet varchar(255),
    add receiving_pres_addr varchar(255),
    add sending_aet varchar(255),
    add sending_pres_addr varchar(255);

update series set sending_aet = src_aet;

create index UK_b9e2bptvail8xnmb62h30h4d2 on series (sending_aet);
create index UK_lnck3a2qjo1vc430n1sy51vbr on series (receiving_aet);
create index UK_gxun7s005k8qf7qwhjhkkkkng on series (sending_pres_addr);
create index UK_e15a6qnq8jcq931agc2v48nvt on series (receiving_pres_addr);

-- part 2: shall be applied on stopped archive before starting 5.23
update person_name
set alphabetic_name = coalesce(family_name, '') || '^' || coalesce(given_name, '') || '^' || coalesce(middle_name, '')
                        || '^' || coalesce(name_prefix, '') || '^' || coalesce(name_suffix, '') || '^',
    ideographic_name = coalesce(i_family_name, '') || '^' || coalesce(i_given_name, '') || '^' || coalesce(i_middle_name, '')
                        || '^' || coalesce(i_name_prefix, '') || '^' || coalesce(i_name_suffix, '') || '^',
    phonetic_name = coalesce(p_family_name, '') || '^' || coalesce(p_given_name, '') || '^' || coalesce(p_middle_name, '')
                        || '^' || coalesce(p_name_prefix, '') || '^' || coalesce(p_name_suffix, '') || '^'
where alphabetic_name is null;

update series set sending_aet = src_aet where sending_aet is null;

-- part 3: can be applied on already running archive 5.23
alter table person_name alter alphabetic_name set not null;
alter table person_name alter ideographic_name set not null;
alter table person_name alter phonetic_name set not null;

alter table person_name drop family_name;
alter table person_name drop given_name;
alter table person_name drop middle_name;
alter table person_name drop name_prefix;
alter table person_name drop name_suffix;
alter table person_name drop i_family_name;
alter table person_name drop i_given_name;
alter table person_name drop i_middle_name;
alter table person_name drop i_name_prefix;
alter table person_name drop i_name_suffix;
alter table person_name drop p_family_name;
alter table person_name drop p_given_name;
alter table person_name drop p_middle_name;
alter table person_name drop p_name_prefix;
alter table person_name drop p_name_suffix;

alter table series drop src_aet;