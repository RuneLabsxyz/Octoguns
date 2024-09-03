impl SessionIntrospect<> of dojo::model::introspect::Introspect<Session<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(4)
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 239309295088010303179674854767833684804913721549493521598274052206420914739,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 404502075166424196538136646530976054889702242338407082171602314481216980001,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 1534444455426300785759355024523600536631340872285658519225469083221951368074,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 854456557106728374519428279941863874167274000421952627226145415297787970838,
                    layout: dojo::model::introspect::Introspect::<u8>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'Session',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'session_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'player1',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'player2',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'map_id',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'state',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u8>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct SessionEntity {
    __id: felt252, // private field
    pub player1: ContractAddress,
    pub player2: ContractAddress,
    pub map_id: u32,
    pub state: u8,
}

#[generate_trait]
pub impl SessionEntityStoreImpl of SessionEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> SessionEntity {
        SessionModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @SessionEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<SessionEntity>::update_entity(self, world);
    }

    fn delete(self: @SessionEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<SessionEntity>::delete_entity(self, world);
    }


    fn get_player1(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            SessionEntity
        >::get_member(
            world,
            entity_id,
            239309295088010303179674854767833684804913721549493521598274052206420914739
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Session::player1`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_player1(
        self: @SessionEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                239309295088010303179674854767833684804913721549493521598274052206420914739,
                serialized.span()
            );
    }

    fn get_player2(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            SessionEntity
        >::get_member(
            world,
            entity_id,
            404502075166424196538136646530976054889702242338407082171602314481216980001
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Session::player2`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_player2(
        self: @SessionEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                404502075166424196538136646530976054889702242338407082171602314481216980001,
                serialized.span()
            );
    }

    fn get_map_id(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            SessionEntity
        >::get_member(
            world,
            entity_id,
            1534444455426300785759355024523600536631340872285658519225469083221951368074
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Session::map_id`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_map_id(self: @SessionEntity, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1534444455426300785759355024523600536631340872285658519225469083221951368074,
                serialized.span()
            );
    }

    fn get_state(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u8 {
        let mut values = dojo::model::ModelEntity::<
            SessionEntity
        >::get_member(
            world,
            entity_id,
            854456557106728374519428279941863874167274000421952627226145415297787970838
        );
        let field_value = core::serde::Serde::<u8>::deserialize(ref values);

        if core::option::OptionTrait::<u8>::is_none(@field_value) {
            panic!("Field `Session::state`: deserialization failed.");
        }

        core::option::OptionTrait::<u8>::unwrap(field_value)
    }

    fn set_state(self: @SessionEntity, world: dojo::world::IWorldDispatcher, value: u8) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                854456557106728374519428279941863874167274000421952627226145415297787970838,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl SessionStoreImpl of SessionStore {
    fn entity_id_from_keys(session_id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> Session {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Session>::deserialize(ref serialized);

        if core::option::OptionTrait::<Session>::is_none(@entity) {
            panic!(
                "Model `Session`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Session>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, session_id: u32) -> Session {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        dojo::model::Model::<Session>::get(world, serialized.span())
    }

    fn set(self: @Session, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Session>::set_model(self, world);
    }

    fn delete(self: @Session, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Session>::delete_model(self, world);
    }


    fn get_player1(world: dojo::world::IWorldDispatcher, session_id: u32) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        let mut values = dojo::model::Model::<
            Session
        >::get_member(
            world,
            serialized.span(),
            239309295088010303179674854767833684804913721549493521598274052206420914739
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Session::player1`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_player1(self: @Session, world: dojo::world::IWorldDispatcher, value: ContractAddress) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                239309295088010303179674854767833684804913721549493521598274052206420914739,
                serialized.span()
            );
    }

    fn get_player2(world: dojo::world::IWorldDispatcher, session_id: u32) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        let mut values = dojo::model::Model::<
            Session
        >::get_member(
            world,
            serialized.span(),
            404502075166424196538136646530976054889702242338407082171602314481216980001
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Session::player2`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_player2(self: @Session, world: dojo::world::IWorldDispatcher, value: ContractAddress) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                404502075166424196538136646530976054889702242338407082171602314481216980001,
                serialized.span()
            );
    }

    fn get_map_id(world: dojo::world::IWorldDispatcher, session_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        let mut values = dojo::model::Model::<
            Session
        >::get_member(
            world,
            serialized.span(),
            1534444455426300785759355024523600536631340872285658519225469083221951368074
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Session::map_id`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_map_id(self: @Session, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1534444455426300785759355024523600536631340872285658519225469083221951368074,
                serialized.span()
            );
    }

    fn get_state(world: dojo::world::IWorldDispatcher, session_id: u32) -> u8 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@session_id, ref serialized);

        let mut values = dojo::model::Model::<
            Session
        >::get_member(
            world,
            serialized.span(),
            854456557106728374519428279941863874167274000421952627226145415297787970838
        );

        let field_value = core::serde::Serde::<u8>::deserialize(ref values);

        if core::option::OptionTrait::<u8>::is_none(@field_value) {
            panic!("Field `Session::state`: deserialization failed.");
        }

        core::option::OptionTrait::<u8>::unwrap(field_value)
    }

    fn set_state(self: @Session, world: dojo::world::IWorldDispatcher, value: u8) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                854456557106728374519428279941863874167274000421952627226145415297787970838,
                serialized.span()
            );
    }
}

pub impl SessionModelEntityImpl of dojo::model::ModelEntity<SessionEntity> {
    fn id(self: @SessionEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @SessionEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.player1, ref serialized);
        core::serde::Serde::serialize(self.player2, ref serialized);
        core::serde::Serde::serialize(self.map_id, ref serialized);
        core::serde::Serde::serialize(self.state, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> SessionEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<SessionEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<SessionEntity>::is_none(@entity_values) {
            panic!("ModelEntity `SessionEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<SessionEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> SessionEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<Session>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<Session>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @SessionEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<Session>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Session>::layout()
        );
    }

    fn delete_entity(self: @SessionEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<Session>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Session>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Session>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<Session>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @SessionEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Session>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<Session>::selector(),
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
pub impl SessionModelEntityTestImpl of dojo::model::ModelEntityTest<SessionEntity> {
    fn update_test(self: @SessionEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Session>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Session>::layout()
        );
    }

    fn delete_test(self: @SessionEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Session>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Session>::layout()
        );
    }
}

pub impl SessionModelImpl of dojo::model::Model<Session> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> Session {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        SessionStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @Session, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @Session, world: dojo::world::IWorldDispatcher) {
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
        self: @Session,
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
        "Session"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-Session"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1860705124153763557080870786122446825830531615507069971503866801501989050735
    }

    #[inline(always)]
    fn instance_selector(self: @Session) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        772052740953146010013380479616858933288826881761594824011753360489719348762
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @Session) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @Session) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.session_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Session) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.player1, ref serialized);
        core::serde::Serde::serialize(self.player2, ref serialized);
        core::serde::Serde::serialize(self.map_id, ref serialized);
        core::serde::Serde::serialize(self.state, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<Session>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Session) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl SessionModelTestImpl of dojo::model::ModelTest<Session> {
    fn set_test(self: @Session, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Session>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Session>::keys(self)),
            dojo::model::Model::<Session>::values(self),
            dojo::model::Model::<Session>::layout()
        );
    }

    fn delete_test(self: @Session, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Session>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Session>::keys(self)),
            dojo::model::Model::<Session>::layout()
        );
    }
}

#[starknet::interface]
pub trait Isession<T> {
    fn ensure_abi(self: @T, model: Session);
}

#[starknet::contract]
pub mod session {
    use super::Session;
    use super::Isession;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Session>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Session>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Session>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Session>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Session>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Session>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Session>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<Session>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Session>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<Session>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<Session>::ty()
        }
    }

    #[abi(embed_v0)]
    impl sessionImpl of Isession<ContractState> {
        fn ensure_abi(self: @ContractState, model: Session) {}
    }
}
