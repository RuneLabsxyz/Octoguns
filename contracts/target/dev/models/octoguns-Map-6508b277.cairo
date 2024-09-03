impl MapIntrospect<> of dojo::model::introspect::Introspect<Map<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 1074958705200745687179360633972103168994830531569350581460623722717786829650,
                    layout: dojo::model::introspect::Introspect::<Array<u32>>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'Map',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'map_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'map_objects_id',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Ty::Array(
                            array![dojo::model::introspect::Introspect::<u32>::ty()].span()
                        )
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct MapEntity {
    __id: felt252, // private field
    pub map_objects_id: Array<u32>,
}

#[generate_trait]
pub impl MapEntityStoreImpl of MapEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> MapEntity {
        MapModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @MapEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<MapEntity>::update_entity(self, world);
    }

    fn delete(self: @MapEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<MapEntity>::delete_entity(self, world);
    }


    fn get_map_objects_id(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Array<u32> {
        let mut values = dojo::model::ModelEntity::<
            MapEntity
        >::get_member(
            world,
            entity_id,
            1074958705200745687179360633972103168994830531569350581460623722717786829650
        );
        let field_value = core::serde::Serde::<Array<u32>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u32>>::is_none(@field_value) {
            panic!("Field `Map::map_objects_id`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u32>>::unwrap(field_value)
    }

    fn set_map_objects_id(
        self: @MapEntity, world: dojo::world::IWorldDispatcher, value: Array<u32>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1074958705200745687179360633972103168994830531569350581460623722717786829650,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl MapStoreImpl of MapStore {
    fn entity_id_from_keys(map_id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@map_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> Map {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Map>::deserialize(ref serialized);

        if core::option::OptionTrait::<Map>::is_none(@entity) {
            panic!(
                "Model `Map`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Map>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, map_id: u32) -> Map {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@map_id, ref serialized);

        dojo::model::Model::<Map>::get(world, serialized.span())
    }

    fn set(self: @Map, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Map>::set_model(self, world);
    }

    fn delete(self: @Map, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Map>::delete_model(self, world);
    }


    fn get_map_objects_id(world: dojo::world::IWorldDispatcher, map_id: u32) -> Array<u32> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@map_id, ref serialized);

        let mut values = dojo::model::Model::<
            Map
        >::get_member(
            world,
            serialized.span(),
            1074958705200745687179360633972103168994830531569350581460623722717786829650
        );

        let field_value = core::serde::Serde::<Array<u32>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u32>>::is_none(@field_value) {
            panic!("Field `Map::map_objects_id`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u32>>::unwrap(field_value)
    }

    fn set_map_objects_id(self: @Map, world: dojo::world::IWorldDispatcher, value: Array<u32>) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1074958705200745687179360633972103168994830531569350581460623722717786829650,
                serialized.span()
            );
    }
}

pub impl MapModelEntityImpl of dojo::model::ModelEntity<MapEntity> {
    fn id(self: @MapEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @MapEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.map_objects_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> MapEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<MapEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<MapEntity>::is_none(@entity_values) {
            panic!("ModelEntity `MapEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<MapEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> MapEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<Map>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<Map>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @MapEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<Map>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Map>::layout()
        );
    }

    fn delete_entity(self: @MapEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<Map>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Map>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(dojo::model::Model::<Map>::layout(), member_id) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<Map>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @MapEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(dojo::model::Model::<Map>::layout(), member_id) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<Map>::selector(),
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
pub impl MapModelEntityTestImpl of dojo::model::ModelEntityTest<MapEntity> {
    fn update_test(self: @MapEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Map>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Map>::layout()
        );
    }

    fn delete_test(self: @MapEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Map>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Map>::layout()
        );
    }
}

pub impl MapModelImpl of dojo::model::Model<Map> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> Map {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        MapStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @Map, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @Map, world: dojo::world::IWorldDispatcher) {
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
        self: @Map, world: dojo::world::IWorldDispatcher, member_id: felt252, values: Span<felt252>
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
        "Map"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-Map"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        2856185264061559378511738126929200816939397823969089311023190857499871462129
    }

    #[inline(always)]
    fn instance_selector(self: @Map) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        1269496421625334591258667971751768006824856658840247273016400406852701859927
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @Map) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @Map) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.map_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Map) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.map_objects_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<Map>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Map) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl MapModelTestImpl of dojo::model::ModelTest<Map> {
    fn set_test(self: @Map, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Map>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Map>::keys(self)),
            dojo::model::Model::<Map>::values(self),
            dojo::model::Model::<Map>::layout()
        );
    }

    fn delete_test(self: @Map, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Map>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Map>::keys(self)),
            dojo::model::Model::<Map>::layout()
        );
    }
}

#[starknet::interface]
pub trait Imap<T> {
    fn ensure_abi(self: @T, model: Map);
}

#[starknet::contract]
pub mod map {
    use super::Map;
    use super::Imap;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Map>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Map>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Map>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Map>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Map>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Map>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Map>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<Map>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Map>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<Map>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<Map>::ty()
        }
    }

    #[abi(embed_v0)]
    impl mapImpl of Imap<ContractState> {
        fn ensure_abi(self: @ContractState, model: Map) {}
    }
}
