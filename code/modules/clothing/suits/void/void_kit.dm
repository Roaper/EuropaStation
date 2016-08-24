/obj/item/clothing/head/helmet/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		name = "[kit.new_name] suit helmet"
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_helmet"
		item_state = "[kit.new_icon]_helmet"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		if(kit.new_light_overlay)
			light_overlay = kit.new_light_overlay
		user << "You set about modifying the helmet into [src]."
		var/mob/living/human/H = user
		if(istype(H))
			species_restricted = list(H.species.get_bodytype())
		kit.use(1,user)
		return 1
	return ..()

/obj/item/clothing/suit/voidsuit/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/device/kit/suit))
		var/obj/item/device/kit/suit/kit = O
		name = "[kit.new_name] voidsuit"
		desc = kit.new_desc
		icon_state = "[kit.new_icon]_suit"
		item_state = "[kit.new_icon]_suit"
		if(kit.new_icon_file)
			icon = kit.new_icon_file
		if(kit.new_mob_icon_file)
			icon_override = kit.new_mob_icon_file
		user << "You set about modifying the suit into [src]."
		var/mob/living/human/H = user
		if(istype(H))
			species_restricted = list(H.species.get_bodytype())
		kit.use(1,user)
		return 1
	return ..()