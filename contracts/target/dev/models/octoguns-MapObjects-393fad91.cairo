impl MapObjectsIntrospect<> of dojo::model::introspect::Introspect<MapObjects<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        let sizes: Array<Option<usize>> = array![
            dojo::model::introspect::Introspect::<Vec2>::size(),
            dojo::model::introspect::Introspect::<Vec2>::size()
        ];

        if dojo::utils::any_none(@sizes) {
            return Option::None;
        }
        Option::Some(dojo::utils::sum(sizes))
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 710739928788045709429479928128092468277926021162774330206611255393280417041,
                    layout: dojo::model::introspect::Introspect::<Vec2>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 523434579778049082916080710659757700509398103366336840486001269446577652416,
                    layout: dojo::model::introspect::Introspect::<Vec2>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'MapObjects',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'map_object_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'dimensions',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<Vec2>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'coords',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<Vec2>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct MapObjectsEntity {
    __id: felt252, // private field
    pub dimensions: Vec2,
    pub coords: Vec2,
}

#[generate_trait]
pub impl MapObjectsEntityStoreImpl of MapObjectsEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> MapObjectsEntity {
        MapObjectsModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @MapObjectsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<MapObjectsEntity>::update_entity(self, world);
    }

    fn delete(self: @MapObjectsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<MapObjectsEntity>::delete_entity(self, world);
    }


    fn get_dimensions(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Vec2 {
        let mut values = dojo::model::ModelEntity::<
            MapObjectsEntity
        >::get_member(
            world,
            entity_id,
            710739928788045709429479928128092468277926021162774330206611255393280417041
        );
        let field_value = core::serde::Serde::<Vec2>::deserialize(ref values);

        if core::option::OptionTrait::<Vec2>::is_none(@field_value) {
            panic!("Field `MapObjects::dimensions`: deserialization failed.");
        }

        core::option::OptionTrait::<Vec2>::unwrap(field_value)
    }

    fn set_dimensions(self: @MapObjectsEntity, world: dojo::world::IWorldDispatcher, value: Vec2) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                710739928788045709429479928128092468277926021162774330206611255393280417041,
                serialized.span()
            );
    }

    fn get_coords(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Vec2 {
        let mut values = dojo::model::ModelEntity::<
            MapObjectsEntity
        >::get_member(
            world,
            entity_id,
            523434579778049082916080710659757700509398103366336840486001269446577652416
        );
        let field_value = core::serde::Serde::<Vec2>::deserialize(ref values);

        if core::option::OptionTrait::<Vec2>::is_none(@field_value) {
            panic!("Field `MapObjects::coords`: deserialization failed.");
        }

        core::option::OptionTrait::<Vec2>::unwrap(field_value)
    }

    fn set_coords(self: @MapObjectsEntity, world: dojo::world::IWorldDispatcher, value: Vec2) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                523434579778049082916080710659757700509398103366336840486001269446577652416,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl MapObjectsStoreImpl of MapObjectsStore {
    fn entity_id_from_keys(map_object_id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@map_object_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> MapObjects {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<MapObjects>::deserialize(ref serialized);

        if core::option::OptionTrait::<MapObjects>::is_none(@entity) {
            panic!(
                "Model `MapObjects`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<MapObjects>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, map_object_id: u32) -> MapObjects {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@map_object_id, ref serialized);

        dojo::model::Model::<MapObjects>::get(world, serialized.span())
    }

    fn set(self: @MapObjects, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<MapObjects>::set_model(self, world);
    }

    fn delete(self: @MapObjects, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<MapObjects>::delete_model(self, world);
    }


    fn get_dimensions(world: dojo::world::IWorldDispatcher, map_object_id: u32) -> Vec2 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@map_object_id, ref serialized);

        let mut values = dojo::model::Model::<
            MapObjects
        >::get_member(
            world,
            serialized.span(),
            710739928788045709429479928128092468277926021162774330206611255393280417041
        );

        let field_value = core::serde::Serde::<Vec2>::deserialize(ref values);

        if core::option::OptionTrait::<Vec2>::is_none(@field_value) {
            panic!("Field `MapObjects::dimensions`: deserialization failed.");
        }

        core::option::OptionTrait::<Vec2>::unwrap(field_value)
    }

    fn set_dimensions(self: @MapObjects, world: dojo::world::IWorldDispatcher, value: Vec2) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                710739928788045709429479928128092468277926021162774330206611255393280417041,
                serialized.span()
            );
    }

    fn get_coords(world: dojo::world::IWorldDispatcher, map_object_id: u32) -> Vec2 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@map_object_id, ref serialized);

        let mut values = dojo::model::Model::<
            MapObjects
        >::get_member(
            world,
            serialized.span(),
            523434579778049082916080710659757700509398103366336840486001269446577652416
        );

        let field_value = core::serde::Serde::<Vec2>::deserialize(ref values);

        if core::option::OptionTrait::<Vec2>::is_none(@field_value) {
            panic!("Field `MapObjects::coords`: deserialization failed.");
        }

        core::option::OptionTrait::<Vec2>::unwrap(field_value)
    }

    fn set_coords(self: @MapObjects, world: dojo::world::IWorldDispatcher, value: Vec2) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                523434579778049082916080710659757700509398103366336840486001269446577652416,
                serialized.span()
            );
    }
}

pub impl MapObjectsModelEntityImpl of dojo::model::ModelEntity<MapObjectsEntity> {
    fn id(self: @MapObjectsEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @MapObjectsEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.dimensions, ref serialized);
        core::serde::Serde::serialize(self.coords, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> MapObjectsEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<MapObjectsEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<MapObjectsEntity>::is_none(@entity_values) {
            panic!("ModelEntity `MapObjectsEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<MapObjectsEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> MapObjectsEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<MapObjects>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<MapObjects>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @MapObjectsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<MapObjects>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<MapObjects>::layout()
        );
    }

    fn delete_entity(self: @MapObjectsEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<MapObjects>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<MapObjects>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<MapObjects>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<MapObjects>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @MapObjectsEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<MapObjects>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<MapObjects>::selector(),
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
pub impl MapObjectsModelEntityTestImpl of dojo::model::ModelEntityTest<MapObjectsEntity> {
    fn update_test(self: @MapObjectsEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<MapObjects>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<MapObjects>::layout()
        );
    }

    fn delete_test(self: @MapObjectsEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<MapObjects>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<MapObjects>::layout()
        );
    }
}

pub impl MapObjectsModelImpl of dojo::model::Model<MapObjects> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> MapObjects {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        MapObjectsStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @MapObjects, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @MapObjects, world: dojo::world::IWorldDispatcher) {
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
        self: @MapObjects,
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
        "MapObjects"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-MapObjects"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1618396353620120069494874126043414015491863868524660071540195674875270867626
    }

    #[inline(always)]
    fn instance_selector(self: @MapObjects) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        1058159533823980688788849479392416681347064837376264705744637661096930052679
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @MapObjects) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @MapObjects) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.map_object_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @MapObjects) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.dimensions, ref serialized);
        core::serde::Serde::serialize(self.coords, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<MapObjects>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @MapObjects) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl MapObjectsModelTestImpl of dojo::model::ModelTest<MapObjects> {
    fn set_test(self: @MapObjects, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<MapObjects>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<MapObjects>::keys(self)),
            dojo::model::Model::<MapObjects>::values(self),
            dojo::model::Model::<MapObjects>::layout()
        );
    }

    fn delete_test(self: @MapObjects, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<MapObjects>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<MapObjects>::keys(self)),
            dojo::model::Model::<MapObjects>::layout()
        );
    }
}

#[starknet::interface]
pub trait Imap_objects<T> {
    fn ensure_abi(self: @T, model: MapObjects);
}

#[starknet::contract]
pub mod map_objects {
    use super::MapObjects;
    use super::Imap_objects;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<MapObjects>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<MapObjects>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<MapObjects>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<MapObjects>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<MapObjects>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<MapObjects>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<MapObjects>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<MapObjects>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<MapObjects>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<MapObjects>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<MapObjects>::ty()
        }
    }

    #[abi(embed_v0)]
    impl map_objectsImpl of Imap_objects<ContractState> {
        fn ensure_abi(self: @ContractState, model: MapObjects) {}
    }
}
