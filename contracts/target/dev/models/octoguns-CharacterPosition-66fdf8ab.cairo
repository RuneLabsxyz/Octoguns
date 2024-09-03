impl CharacterPositionIntrospect<> of dojo::model::introspect::Introspect<CharacterPosition<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        let sizes: Array<Option<usize>> = array![
            dojo::model::introspect::Introspect::<Vec2>::size(), Option::Some(2)
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
                    selector: 523434579778049082916080710659757700509398103366336840486001269446577652416,
                    layout: dojo::model::introspect::Introspect::<Vec2>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1595221499095247688670472121189248232025058407091972015638630151436812915316,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1362666958069555938073995941304570851066844596326821884013832719141653492866,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'CharacterPosition',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'coords',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<Vec2>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'max_steps',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'current_step',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct CharacterPositionEntity {
    __id: felt252, // private field
    pub coords: Vec2,
    pub max_steps: u32,
    pub current_step: u32,
}

#[generate_trait]
pub impl CharacterPositionEntityStoreImpl of CharacterPositionEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> CharacterPositionEntity {
        CharacterPositionModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<CharacterPositionEntity>::update_entity(self, world);
    }

    fn delete(self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<CharacterPositionEntity>::delete_entity(self, world);
    }


    fn get_coords(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Vec2 {
        let mut values = dojo::model::ModelEntity::<
            CharacterPositionEntity
        >::get_member(
            world,
            entity_id,
            523434579778049082916080710659757700509398103366336840486001269446577652416
        );
        let field_value = core::serde::Serde::<Vec2>::deserialize(ref values);

        if core::option::OptionTrait::<Vec2>::is_none(@field_value) {
            panic!("Field `CharacterPosition::coords`: deserialization failed.");
        }

        core::option::OptionTrait::<Vec2>::unwrap(field_value)
    }

    fn set_coords(
        self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher, value: Vec2
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                523434579778049082916080710659757700509398103366336840486001269446577652416,
                serialized.span()
            );
    }

    fn get_max_steps(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            CharacterPositionEntity
        >::get_member(
            world,
            entity_id,
            1595221499095247688670472121189248232025058407091972015638630151436812915316
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `CharacterPosition::max_steps`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_max_steps(
        self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher, value: u32
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1595221499095247688670472121189248232025058407091972015638630151436812915316,
                serialized.span()
            );
    }

    fn get_current_step(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            CharacterPositionEntity
        >::get_member(
            world,
            entity_id,
            1362666958069555938073995941304570851066844596326821884013832719141653492866
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `CharacterPosition::current_step`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_current_step(
        self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher, value: u32
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1362666958069555938073995941304570851066844596326821884013832719141653492866,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl CharacterPositionStoreImpl of CharacterPositionStore {
    fn entity_id_from_keys(id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> CharacterPosition {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<CharacterPosition>::deserialize(ref serialized);

        if core::option::OptionTrait::<CharacterPosition>::is_none(@entity) {
            panic!(
                "Model `CharacterPosition`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<CharacterPosition>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, id: u32) -> CharacterPosition {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@id, ref serialized);

        dojo::model::Model::<CharacterPosition>::get(world, serialized.span())
    }

    fn set(self: @CharacterPosition, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<CharacterPosition>::set_model(self, world);
    }

    fn delete(self: @CharacterPosition, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<CharacterPosition>::delete_model(self, world);
    }


    fn get_coords(world: dojo::world::IWorldDispatcher, id: u32) -> Vec2 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@id, ref serialized);

        let mut values = dojo::model::Model::<
            CharacterPosition
        >::get_member(
            world,
            serialized.span(),
            523434579778049082916080710659757700509398103366336840486001269446577652416
        );

        let field_value = core::serde::Serde::<Vec2>::deserialize(ref values);

        if core::option::OptionTrait::<Vec2>::is_none(@field_value) {
            panic!("Field `CharacterPosition::coords`: deserialization failed.");
        }

        core::option::OptionTrait::<Vec2>::unwrap(field_value)
    }

    fn set_coords(self: @CharacterPosition, world: dojo::world::IWorldDispatcher, value: Vec2) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                523434579778049082916080710659757700509398103366336840486001269446577652416,
                serialized.span()
            );
    }

    fn get_max_steps(world: dojo::world::IWorldDispatcher, id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@id, ref serialized);

        let mut values = dojo::model::Model::<
            CharacterPosition
        >::get_member(
            world,
            serialized.span(),
            1595221499095247688670472121189248232025058407091972015638630151436812915316
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `CharacterPosition::max_steps`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_max_steps(self: @CharacterPosition, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1595221499095247688670472121189248232025058407091972015638630151436812915316,
                serialized.span()
            );
    }

    fn get_current_step(world: dojo::world::IWorldDispatcher, id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@id, ref serialized);

        let mut values = dojo::model::Model::<
            CharacterPosition
        >::get_member(
            world,
            serialized.span(),
            1362666958069555938073995941304570851066844596326821884013832719141653492866
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `CharacterPosition::current_step`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_current_step(
        self: @CharacterPosition, world: dojo::world::IWorldDispatcher, value: u32
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1362666958069555938073995941304570851066844596326821884013832719141653492866,
                serialized.span()
            );
    }
}

pub impl CharacterPositionModelEntityImpl of dojo::model::ModelEntity<CharacterPositionEntity> {
    fn id(self: @CharacterPositionEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @CharacterPositionEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.coords, ref serialized);
        core::serde::Serde::serialize(self.max_steps, ref serialized);
        core::serde::Serde::serialize(self.current_step, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> CharacterPositionEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<
            CharacterPositionEntity
        >::deserialize(ref serialized);
        if core::option::OptionTrait::<CharacterPositionEntity>::is_none(@entity_values) {
            panic!("ModelEntity `CharacterPositionEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<CharacterPositionEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> CharacterPositionEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<CharacterPosition>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<CharacterPosition>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<CharacterPosition>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<CharacterPosition>::layout()
        );
    }

    fn delete_entity(self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<CharacterPosition>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<CharacterPosition>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<CharacterPosition>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<CharacterPosition>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @CharacterPositionEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<CharacterPosition>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<CharacterPosition>::selector(),
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
pub impl CharacterPositionModelEntityTestImpl of dojo::model::ModelEntityTest<
    CharacterPositionEntity
> {
    fn update_test(self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<CharacterPosition>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<CharacterPosition>::layout()
        );
    }

    fn delete_test(self: @CharacterPositionEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<CharacterPosition>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<CharacterPosition>::layout()
        );
    }
}

pub impl CharacterPositionModelImpl of dojo::model::Model<CharacterPosition> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> CharacterPosition {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        CharacterPositionStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @CharacterPosition, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @CharacterPosition, world: dojo::world::IWorldDispatcher) {
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
        self: @CharacterPosition,
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
        "CharacterPosition"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-CharacterPosition"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        2911539944621071114323380537622559371625095845354948670478850428890430205305
    }

    #[inline(always)]
    fn instance_selector(self: @CharacterPosition) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        3556725281991475033973890841906632145065871068874045767659444862065036984741
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @CharacterPosition) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @CharacterPosition) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @CharacterPosition) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.coords, ref serialized);
        core::serde::Serde::serialize(self.max_steps, ref serialized);
        core::serde::Serde::serialize(self.current_step, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<CharacterPosition>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @CharacterPosition) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl CharacterPositionModelTestImpl of dojo::model::ModelTest<CharacterPosition> {
    fn set_test(self: @CharacterPosition, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<CharacterPosition>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<CharacterPosition>::keys(self)),
            dojo::model::Model::<CharacterPosition>::values(self),
            dojo::model::Model::<CharacterPosition>::layout()
        );
    }

    fn delete_test(self: @CharacterPosition, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<CharacterPosition>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<CharacterPosition>::keys(self)),
            dojo::model::Model::<CharacterPosition>::layout()
        );
    }
}

#[starknet::interface]
pub trait Icharacter_position<T> {
    fn ensure_abi(self: @T, model: CharacterPosition);
}

#[starknet::contract]
pub mod character_position {
    use super::CharacterPosition;
    use super::Icharacter_position;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<CharacterPosition>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<CharacterPosition>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<CharacterPosition>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<CharacterPosition>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<CharacterPosition>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<CharacterPosition>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<CharacterPosition>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<CharacterPosition>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<CharacterPosition>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<CharacterPosition>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<CharacterPosition>::ty()
        }
    }

    #[abi(embed_v0)]
    impl character_positionImpl of Icharacter_position<ContractState> {
        fn ensure_abi(self: @ContractState, model: CharacterPosition) {}
    }
}
