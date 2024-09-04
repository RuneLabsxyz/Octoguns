impl SessionMetaIntrospect<> of dojo::model::introspect::Introspect<SessionMeta<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 311870549505066544233290795223000778018518288586495757241583054360127774347,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 128321575940958285562153927656423268117249006033863000347643251811109251498,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1518652711324629812385680852336538456702608973173079436249590480105867639192,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 937767295702124354420787697265174939173153106381800505936902334422534990348,
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
                name: 'SessionMeta',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'session_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'turn_count',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'p1_character',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'p2_character',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'bullets',
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
pub struct SessionMetaEntity {
    __id: felt252, // private field
    pub turn_count: u32,
    pub p1_character: u32,
    pub p2_character: u32,
    pub bullets: Array<u32>,
}

#[generate_trait]
pub impl SessionMetaEntityStoreImpl of SessionMetaEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> SessionMetaEntity {
        SessionMetaModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<SessionMetaEntity>::update_entity(self, world);
    }

    fn delete(self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<SessionMetaEntity>::delete_entity(self, world);
    }


    fn get_turn_count(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            SessionMetaEntity
        >::get_member(
            world,
            entity_id,
            311870549505066544233290795223000778018518288586495757241583054360127774347
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `SessionMeta::turn_count`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_turn_count(self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                311870549505066544233290795223000778018518288586495757241583054360127774347,
                serialized.span()
            );
    }

    fn get_p1_character(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            SessionMetaEntity
        >::get_member(
            world,
            entity_id,
            128321575940958285562153927656423268117249006033863000347643251811109251498
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `SessionMeta::p1_character`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_p1_character(
        self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher, value: u32
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                128321575940958285562153927656423268117249006033863000347643251811109251498,
                serialized.span()
            );
    }

    fn get_p2_character(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            SessionMetaEntity
        >::get_member(
            world,
            entity_id,
            1518652711324629812385680852336538456702608973173079436249590480105867639192
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `SessionMeta::p2_character`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_p2_character(
        self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher, value: u32
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1518652711324629812385680852336538456702608973173079436249590480105867639192,
                serialized.span()
            );
    }

    fn get_bullets(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Array<u32> {
        let mut values = dojo::model::ModelEntity::<
            SessionMetaEntity
        >::get_member(
            world,
            entity_id,
            937767295702124354420787697265174939173153106381800505936902334422534990348
        );
        let field_value = core::serde::Serde::<Array<u32>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u32>>::is_none(@field_value) {
            panic!("Field `SessionMeta::bullets`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u32>>::unwrap(field_value)
    }

    fn set_bullets(
        self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher, value: Array<u32>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                937767295702124354420787697265174939173153106381800505936902334422534990348,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl SessionMetaStoreImpl of SessionMetaStore {
    fn entity_id_from_keys(session_id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> SessionMeta {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<SessionMeta>::deserialize(ref serialized);

        if core::option::OptionTrait::<SessionMeta>::is_none(@entity) {
            panic!(
                "Model `SessionMeta`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<SessionMeta>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, session_id: u32) -> SessionMeta {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        dojo::model::Model::<SessionMeta>::get(world, serialized.span())
    }

    fn set(self: @SessionMeta, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<SessionMeta>::set_model(self, world);
    }

    fn delete(self: @SessionMeta, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<SessionMeta>::delete_model(self, world);
    }


    fn get_turn_count(world: dojo::world::IWorldDispatcher, session_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        let mut values = dojo::model::Model::<
            SessionMeta
        >::get_member(
            world,
            serialized.span(),
            311870549505066544233290795223000778018518288586495757241583054360127774347
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `SessionMeta::turn_count`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_turn_count(self: @SessionMeta, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                311870549505066544233290795223000778018518288586495757241583054360127774347,
                serialized.span()
            );
    }

    fn get_p1_character(world: dojo::world::IWorldDispatcher, session_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        let mut values = dojo::model::Model::<
            SessionMeta
        >::get_member(
            world,
            serialized.span(),
            128321575940958285562153927656423268117249006033863000347643251811109251498
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `SessionMeta::p1_character`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_p1_character(self: @SessionMeta, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                128321575940958285562153927656423268117249006033863000347643251811109251498,
                serialized.span()
            );
    }

    fn get_p2_character(world: dojo::world::IWorldDispatcher, session_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        let mut values = dojo::model::Model::<
            SessionMeta
        >::get_member(
            world,
            serialized.span(),
            1518652711324629812385680852336538456702608973173079436249590480105867639192
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `SessionMeta::p2_character`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_p2_character(self: @SessionMeta, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1518652711324629812385680852336538456702608973173079436249590480105867639192,
                serialized.span()
            );
    }

    fn get_bullets(world: dojo::world::IWorldDispatcher, session_id: u32) -> Array<u32> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        let mut values = dojo::model::Model::<
            SessionMeta
        >::get_member(
            world,
            serialized.span(),
            937767295702124354420787697265174939173153106381800505936902334422534990348
        );

        let field_value = core::serde::Serde::<Array<u32>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u32>>::is_none(@field_value) {
            panic!("Field `SessionMeta::bullets`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u32>>::unwrap(field_value)
    }

    fn set_bullets(self: @SessionMeta, world: dojo::world::IWorldDispatcher, value: Array<u32>) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                937767295702124354420787697265174939173153106381800505936902334422534990348,
                serialized.span()
            );
    }
}

pub impl SessionMetaModelEntityImpl of dojo::model::ModelEntity<SessionMetaEntity> {
    fn id(self: @SessionMetaEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @SessionMetaEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.turn_count, ref serialized);
        core::serde::Serde::serialize(self.p1_character, ref serialized);
        core::serde::Serde::serialize(self.p2_character, ref serialized);
        core::serde::Serde::serialize(self.bullets, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> SessionMetaEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<SessionMetaEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<SessionMetaEntity>::is_none(@entity_values) {
            panic!("ModelEntity `SessionMetaEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<SessionMetaEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> SessionMetaEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<SessionMeta>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<SessionMeta>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<SessionMeta>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<SessionMeta>::layout()
        );
    }

    fn delete_entity(self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<SessionMeta>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<SessionMeta>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<SessionMeta>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<SessionMeta>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @SessionMetaEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<SessionMeta>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<SessionMeta>::selector(),
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
pub impl SessionMetaModelEntityTestImpl of dojo::model::ModelEntityTest<SessionMetaEntity> {
    fn update_test(self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<SessionMeta>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<SessionMeta>::layout()
        );
    }

    fn delete_test(self: @SessionMetaEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<SessionMeta>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<SessionMeta>::layout()
        );
    }
}

pub impl SessionMetaModelImpl of dojo::model::Model<SessionMeta> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> SessionMeta {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        SessionMetaStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @SessionMeta, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @SessionMeta, world: dojo::world::IWorldDispatcher) {
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
        self: @SessionMeta,
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
        "SessionMeta"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-SessionMeta"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        2247412863538932713488751747542602714735725067137709406033561420670783293453
    }

    #[inline(always)]
    fn instance_selector(self: @SessionMeta) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        2603809362389220489169181300636391570172207768397284767021497812976750291922
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @SessionMeta) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @SessionMeta) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.session_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @SessionMeta) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.turn_count, ref serialized);
        core::serde::Serde::serialize(self.p1_character, ref serialized);
        core::serde::Serde::serialize(self.p2_character, ref serialized);
        core::serde::Serde::serialize(self.bullets, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<SessionMeta>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @SessionMeta) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl SessionMetaModelTestImpl of dojo::model::ModelTest<SessionMeta> {
    fn set_test(self: @SessionMeta, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<SessionMeta>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<SessionMeta>::keys(self)),
            dojo::model::Model::<SessionMeta>::values(self),
            dojo::model::Model::<SessionMeta>::layout()
        );
    }

    fn delete_test(self: @SessionMeta, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<SessionMeta>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<SessionMeta>::keys(self)),
            dojo::model::Model::<SessionMeta>::layout()
        );
    }
}

#[starknet::interface]
pub trait Isession_meta<T> {
    fn ensure_abi(self: @T, model: SessionMeta);
}

#[starknet::contract]
pub mod session_meta {
    use super::SessionMeta;
    use super::Isession_meta;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<SessionMeta>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<SessionMeta>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<SessionMeta>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<SessionMeta>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<SessionMeta>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<SessionMeta>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<SessionMeta>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<SessionMeta>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<SessionMeta>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<SessionMeta>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<SessionMeta>::ty()
        }
    }

    #[abi(embed_v0)]
    impl session_metaImpl of Isession_meta<ContractState> {
        fn ensure_abi(self: @ContractState, model: SessionMeta) {}
    }
}
