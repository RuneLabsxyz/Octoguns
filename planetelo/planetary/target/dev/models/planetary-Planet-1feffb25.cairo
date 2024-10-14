impl PlanetIntrospect<> of dojo::model::introspect::Introspect<Planet<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(2)
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 867119413717666383599399855818111505388815223614607367740601746836077041298,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1667505759371778332660109374390095004074955190575227499995118192828101868921,
                    layout: dojo::model::introspect::Introspect::<bool>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'Planet',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'name',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<felt252>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'world_address',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'is_available',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<bool>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct PlanetEntity {
    __id: felt252, // private field
    pub world_address: ContractAddress,
    pub is_available: bool,
}

#[generate_trait]
pub impl PlanetEntityStoreImpl of PlanetEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> PlanetEntity {
        PlanetModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @PlanetEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<PlanetEntity>::update_entity(self, world);
    }

    fn delete(self: @PlanetEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<PlanetEntity>::delete_entity(self, world);
    }


    fn get_world_address(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            PlanetEntity
        >::get_member(
            world,
            entity_id,
            867119413717666383599399855818111505388815223614607367740601746836077041298
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Planet::world_address`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_world_address(
        self: @PlanetEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                867119413717666383599399855818111505388815223614607367740601746836077041298,
                serialized.span()
            );
    }

    fn get_is_available(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> bool {
        let mut values = dojo::model::ModelEntity::<
            PlanetEntity
        >::get_member(
            world,
            entity_id,
            1667505759371778332660109374390095004074955190575227499995118192828101868921
        );
        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `Planet::is_available`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_is_available(self: @PlanetEntity, world: dojo::world::IWorldDispatcher, value: bool) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1667505759371778332660109374390095004074955190575227499995118192828101868921,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl PlanetStoreImpl of PlanetStore {
    fn entity_id_from_keys(name: felt252) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, name);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> Planet {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Planet>::deserialize(ref serialized);

        if core::option::OptionTrait::<Planet>::is_none(@entity) {
            panic!(
                "Model `Planet`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Planet>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, name: felt252) -> Planet {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, name);

        dojo::model::Model::<Planet>::get(world, serialized.span())
    }

    fn set(self: @Planet, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Planet>::set_model(self, world);
    }

    fn delete(self: @Planet, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Planet>::delete_model(self, world);
    }


    fn get_world_address(world: dojo::world::IWorldDispatcher, name: felt252) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, name);

        let mut values = dojo::model::Model::<
            Planet
        >::get_member(
            world,
            serialized.span(),
            867119413717666383599399855818111505388815223614607367740601746836077041298
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Planet::world_address`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_world_address(
        self: @Planet, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                867119413717666383599399855818111505388815223614607367740601746836077041298,
                serialized.span()
            );
    }

    fn get_is_available(world: dojo::world::IWorldDispatcher, name: felt252) -> bool {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, name);

        let mut values = dojo::model::Model::<
            Planet
        >::get_member(
            world,
            serialized.span(),
            1667505759371778332660109374390095004074955190575227499995118192828101868921
        );

        let field_value = core::serde::Serde::<bool>::deserialize(ref values);

        if core::option::OptionTrait::<bool>::is_none(@field_value) {
            panic!("Field `Planet::is_available`: deserialization failed.");
        }

        core::option::OptionTrait::<bool>::unwrap(field_value)
    }

    fn set_is_available(self: @Planet, world: dojo::world::IWorldDispatcher, value: bool) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1667505759371778332660109374390095004074955190575227499995118192828101868921,
                serialized.span()
            );
    }
}

pub impl PlanetModelEntityImpl of dojo::model::ModelEntity<PlanetEntity> {
    fn id(self: @PlanetEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @PlanetEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.world_address, ref serialized);
        core::serde::Serde::serialize(self.is_available, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> PlanetEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<PlanetEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<PlanetEntity>::is_none(@entity_values) {
            panic!("ModelEntity `PlanetEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<PlanetEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> PlanetEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<Planet>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<Planet>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @PlanetEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<Planet>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Planet>::layout()
        );
    }

    fn delete_entity(self: @PlanetEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<Planet>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Planet>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Planet>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<Planet>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @PlanetEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Planet>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<Planet>::selector(),
                    dojo::model::ModelIndex::MemberId((self.id(), member_id)),
                    values,
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }
}

#[cfg(target: "test")]
pub impl PlanetModelEntityTestImpl of dojo::model::ModelEntityTest<PlanetEntity> {
    fn update_test(self: @PlanetEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Planet>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Planet>::layout()
        );
    }

    fn delete_test(self: @PlanetEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Planet>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Planet>::layout()
        );
    }
}

pub impl PlanetModelImpl of dojo::model::Model<Planet> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> Planet {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        PlanetStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @Planet, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @Planet, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(Self::keys(self)), Self::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, keys: Span<felt252>, member_id: felt252
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(Self::layout(), member_id) {
            Option::Some(field_layout) => {
                let entity_id = dojo::utils::entity_id_from_keys(keys);
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    Self::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @Planet,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>
    ) {
        match dojo::utils::find_model_field_layout(Self::layout(), member_id) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    Self::selector(),
                    dojo::model::ModelIndex::MemberId((self.entity_id(), member_id)),
                    values,
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    #[inline(always)]
    fn name() -> ByteArray {
        "Planet"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "planetary"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "planetary-Planet"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        902856756752491365981116533202480799370252607661331281980653841477258521966
    }

    #[inline(always)]
    fn instance_selector(self: @Planet) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        10841718682318357493655153499710235659843927915236101962713048058572243554
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        2276933370664470240081104061729369934160808170901121539663944855600660169724
    }

    #[inline(always)]
    fn entity_id(self: @Planet) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @Planet) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::array::ArrayTrait::append(ref serialized, *self.name);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Planet) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.world_address, ref serialized);
        core::serde::Serde::serialize(self.is_available, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<Planet>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Planet) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl PlanetModelTestImpl of dojo::model::ModelTest<Planet> {
    fn set_test(self: @Planet, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Planet>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Planet>::keys(self)),
            dojo::model::Model::<Planet>::values(self),
            dojo::model::Model::<Planet>::layout()
        );
    }

    fn delete_test(self: @Planet, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Planet>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Planet>::keys(self)),
            dojo::model::Model::<Planet>::layout()
        );
    }
}

#[starknet::interface]
pub trait Iplanet<T> {
    fn ensure_abi(self: @T, model: Planet);
}

#[starknet::contract]
pub mod planet {
    use super::Planet;
    use super::Iplanet;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            "Planet"
        }

        fn namespace(self: @ContractState) -> ByteArray {
            "planetary"
        }

        fn tag(self: @ContractState) -> ByteArray {
            "planetary-Planet"
        }

        fn version(self: @ContractState) -> u8 {
            1
        }

        fn selector(self: @ContractState) -> felt252 {
            902856756752491365981116533202480799370252607661331281980653841477258521966
        }

        fn name_hash(self: @ContractState) -> felt252 {
            10841718682318357493655153499710235659843927915236101962713048058572243554
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            2276933370664470240081104061729369934160808170901121539663944855600660169724
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<Planet>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Planet>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<Planet>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<Planet>::ty()
        }
    }

    #[abi(embed_v0)]
    impl planetImpl of Iplanet<ContractState> {
        fn ensure_abi(self: @ContractState, model: Planet) {}
    }
}
