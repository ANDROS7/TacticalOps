// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_mp_usmc_recon");
	self attach("head_mp_usmc_nomex", "", true);
	self setViewmodel("viewhands_mohw_marines");
	self.voice = "american";
}

precache()
{
	precacheModel("body_mp_usmc_recon");
	precacheModel("head_mp_usmc_nomex");
	precacheModel("viewhands_mohw_marines");
}