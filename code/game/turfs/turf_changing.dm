/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(get_base_turf_by_area(src))
	spawn()
		new /obj/structure/lattice( locate(src.x, src.y, src.z) )

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)
// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()
	var/turf/simulated/open/T = GetAbove(src)
	if(istype(T))
		T.update_icon()

//Creates a new turf
/turf/proc/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0)
	if (!N)
		return

	// This makes sure that turfs are not changed to space when one side is part of a zone
	if(N == /turf/space)
		var/turf/below = GetBelow(src)
		if(istype(below) && !istype(below,/turf/space))
			N = /turf/simulated/open

	var/old_ao_neighbors = ao_neighbors
	var/obj/fire/old_fire = fire
	var/list/old_affecting_lights = affecting_lights
	for(var/thing in affecting_lights)
		if(thing)
			var/obj/effect/light/L = thing
			L.affecting_turfs -= src

	//world << "Replacing [src.type] with [N]"


	if(connections) connections.erase_all()

	overlays.Cut()
	underlays.Cut()
	if(istype(src,/turf/simulated))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(S.zone) S.zone.rebuild()

	var/turf/simulated/W = new N( locate(src.x, src.y, src.z) )

	if(ispath(N, /turf/simulated))
		if(old_fire)
			fire = old_fire
		if (istype(W,/turf/simulated/floor))
			W.RemoveLattice()
	else if(old_fire)
		old_fire.RemoveFire()

	if(tell_universe)
		universe.OnTurfChange(W)

	SSair.mark_for_update(src) //handle the addition of the new turf.

	W.post_change()
	. = W

	W.ao_neighbors = old_ao_neighbors

	affecting_lights = old_affecting_lights
	for(var/thing in affecting_lights)
		var/obj/effect/light/L = thing
		L.affecting_turfs |= src

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0

	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	return 1

//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(!src.air)
			src.make_air()
		src.air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1


//No idea why resetting the base appearence from New() isn't enough, but without this it doesn't work
/turf/simulated/shuttle/wall/corner/transport_properties_from(turf/simulated/other)
	. = ..()
	reset_base_appearance()
