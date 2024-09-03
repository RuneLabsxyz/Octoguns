impl GlobalIntrospect<> of dojo::model::introspect::Introspect<Global<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::None
    }

    fn layout() -> dojo::model::Layout {
        dojo::model::Layout::Struct(
            array![
                dojo::model::FieldLayout {
                    selector: 1322020377704496253037376098459562388162682366270681063812101150988845949143,
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
                name: 'Global',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'pending_sessions',
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
pub struct GlobalEntity {
    __id: felt252, // private field
    pub pending_sessions: Array<u32>,
}

#[generate_trait]
pub impl GlobalEntityStoreImpl of GlobalEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> GlobalEntity {
        GlobalModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @GlobalEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<GlobalEntity>::update_entity(self, world);
    }

    fn delete(self: @GlobalEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<GlobalEntity>::delete_entity(self, world);
    }


    fn get_pending_sessions(
        world: dojo::world::IWorldDispatcher, entity_id: felt252
    ) -> Array<u32> {
        let mut values = dojo::model::ModelEntity::<
            GlobalEntity
        >::get_member(
            world,
            entity_id,
            1322020377704496253037376098459562388162682366270681063812101150988845949143
        );
        let field_value = core::serde::Serde::<Array<u32>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u32>>::is_none(@field_value) {
            panic!("Field `Global::pending_sessions`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u32>>::unwrap(field_value)
    }

    fn set_pending_sessions(
        self: @GlobalEntity, world: dojo::world::IWorldDispatcher, value: Array<u32>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1322020377704496253037376098459562388162682366270681063812101150988845949143,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl GlobalStoreImpl of GlobalStore {
    fn entity_id_from_keys(id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> Global {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Global>::deserialize(ref serialized);

        if core::option::OptionTrait::<Global>::is_none(@entity) {
            panic!(
                "Model `Global`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Global>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, id: u32) -> Global {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@id, ref serialized);

        dojo::model::Model::<Global>::get(world, serialized.span())
    }

    fn set(self: @Global, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Global>::set_model(self, world);
    }

    fn delete(self: @Global, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Global>::delete_model(self, world);
    }


    fn get_pending_sessions(world: dojo::world::IWorldDispatcher, id: u32) -> Array<u32> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@id, ref serialized);

        let mut values = dojo::model::Model::<
            Global
        >::get_member(
            world,
            serialized.span(),
            1322020377704496253037376098459562388162682366270681063812101150988845949143
        );

        let field_value = core::serde::Serde::<Array<u32>>::deserialize(ref values);

        if core::option::OptionTrait::<Array<u32>>::is_none(@field_value) {
            panic!("Field `Global::pending_sessions`: deserialization failed.");
        }

        core::option::OptionTrait::<Array<u32>>::unwrap(field_value)
    }

    fn set_pending_sessions(
        self: @Global, world: dojo::world::IWorldDispatcher, value: Array<u32>
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1322020377704496253037376098459562388162682366270681063812101150988845949143,
                serialized.span()
            );
    }
}

pub impl GlobalModelEntityImpl of dojo::model::ModelEntity<GlobalEntity> {
    fn id(self: @GlobalEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @GlobalEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.pending_sessions, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> GlobalEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<GlobalEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<GlobalEntity>::is_none(@entity_values) {
            panic!("ModelEntity `GlobalEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<GlobalEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> GlobalEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<Global>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<Global>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @GlobalEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<Global>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Global>::layout()
        );
    }

    fn delete_entity(self: @GlobalEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<Global>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Global>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Global>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<Global>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @GlobalEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Global>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<Global>::selector(),
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
pub impl GlobalModelEntityTestImpl of dojo::model::ModelEntityTest<GlobalEntity> {
    fn update_test(self: @GlobalEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Global>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Global>::layout()
        );
    }

    fn delete_test(self: @GlobalEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Global>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Global>::layout()
        );
    }
}

pub impl GlobalModelImpl of dojo::model::Model<Global> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> Global {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        GlobalStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @Global, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @Global, world: dojo::world::IWorldDispatcher) {
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
        self: @Global,
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
        "Global"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-Global"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1011740612747917645953321188174176274296954542909319635434679778524873371018
    }

    #[inline(always)]
    fn instance_selector(self: @Global) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        3108102736174231434646319203978891420867352291335829571091481402325369889476
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @Global) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @Global) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Global) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.pending_sessions, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<Global>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Global) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl GlobalModelTestImpl of dojo::model::ModelTest<Global> {
    fn set_test(self: @Global, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Global>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Global>::keys(self)),
            dojo::model::Model::<Global>::values(self),
            dojo::model::Model::<Global>::layout()
        );
    }

    fn delete_test(self: @Global, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Global>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Global>::keys(self)),
            dojo::model::Model::<Global>::layout()
        );
    }
}

#[starknet::interface]
pub trait Iglobal<T> {
    fn ensure_abi(self: @T, model: Global);
}

#[starknet::contract]
pub mod global {
    use super::Global;
    use super::Iglobal;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Global>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Global>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Global>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Global>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Global>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Global>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Global>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<Global>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Global>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<Global>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<Global>::ty()
        }
    }

    #[abi(embed_v0)]
    impl globalImpl of Iglobal<ContractState> {
        fn ensure_abi(self: @ContractState, model: Global) {}
    }
}
