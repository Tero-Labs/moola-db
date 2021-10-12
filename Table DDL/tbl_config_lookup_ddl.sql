-- public.tbl_config_lookup definition

-- Drop table

-- DROP TABLE public.tbl_config_lookup;

CREATE TABLE public.tbl_config_lookup (
	id_config_lookup uuid NOT NULL DEFAULT uuid_generate_v1(),
	item varchar(32) NOT NULL,
	item_value numeric NOT NULL,
	item_value_type varchar(16) NULL,
	tag varchar(8) NULL,
	ip inet NULL,
	record_comment varchar(32) NULL,
	update_datetime timestamptz NULL,
	creation_datetime timestamptz NULL DEFAULT now(),
	enabled bool NULL DEFAULT true,
	CONSTRAINT tbl_config_lookup_pkey PRIMARY KEY (id_config_lookup)
);

-- Permissions

ALTER TABLE public.tbl_config_lookup OWNER TO u5p3hgrt8h7nt4;
GRANT ALL ON TABLE public.tbl_config_lookup TO u5p3hgrt8h7nt4;

