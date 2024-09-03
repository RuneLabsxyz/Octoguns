impl BulletIntrospect<> of dojo::model::introspect::Introspect<Bullet<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        let sizes: Array<Option<usize>> = array![
            dojo::model::introspect::Introspect::<Vec2>::size(), Option::Some(3)
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
                    selector: 1193789348886335288578152519572796512457833789278870806279892559193678609875,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 614499057413201613508653200066187686724488589622048075426255068221310241069,
                    layout: dojo::model::introspect::Introspect::<u32>::layout()
                },
                dojo::model::FieldLayout {
                    selector: 588698628524500455708677857476613685638278177895149671674604026323202882523,
                    layout: dojo::model::introspect::Introspect::<ContractAddress>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::model::introspect::Ty {
        dojo::model::introspect::Ty::Struct(
            dojo::model::introspect::Struct {
                name: 'Bullet',
                attrs: array![].span(),
                children: array![
                    dojo::model::introspect::Member {
                        name: 'bullet_id',
                        attrs: array!['key'].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'coords',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<Vec2>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'speed',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'direction',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<u32>::ty()
                    },
                    dojo::model::introspect::Member {
                        name: 'shot_by',
                        attrs: array![].span(),
                        ty: dojo::model::introspect::Introspect::<ContractAddress>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

#[derive(Drop, Serde)]
pub struct BulletEntity {
    __id: felt252, // private field
    pub coords: Vec2,
    pub speed: u32,
    pub direction: u32,
    pub shot_by: ContractAddress,
}

#[generate_trait]
pub impl BulletEntityStoreImpl of BulletEntityStore {
    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> BulletEntity {
        BulletModelEntityImpl::get(world, entity_id)
    }

    fn update(self: @BulletEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<BulletEntity>::update_entity(self, world);
    }

    fn delete(self: @BulletEntity, world: dojo::world::IWorldDispatcher) {
        dojo::model::ModelEntity::<BulletEntity>::delete_entity(self, world);
    }


    fn get_coords(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> Vec2 {
        let mut values = dojo::model::ModelEntity::<
            BulletEntity
        >::get_member(
            world,
            entity_id,
            523434579778049082916080710659757700509398103366336840486001269446577652416
        );
        let field_value = core::serde::Serde::<Vec2>::deserialize(ref values);

        if core::option::OptionTrait::<Vec2>::is_none(@field_value) {
            panic!("Field `Bullet::coords`: deserialization failed.");
        }

        core::option::OptionTrait::<Vec2>::unwrap(field_value)
    }

    fn set_coords(self: @BulletEntity, world: dojo::world::IWorldDispatcher, value: Vec2) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                523434579778049082916080710659757700509398103366336840486001269446577652416,
                serialized.span()
            );
    }

    fn get_speed(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            BulletEntity
        >::get_member(
            world,
            entity_id,
            1193789348886335288578152519572796512457833789278870806279892559193678609875
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Bullet::speed`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_speed(self: @BulletEntity, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1193789348886335288578152519572796512457833789278870806279892559193678609875,
                serialized.span()
            );
    }

    fn get_direction(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> u32 {
        let mut values = dojo::model::ModelEntity::<
            BulletEntity
        >::get_member(
            world,
            entity_id,
            614499057413201613508653200066187686724488589622048075426255068221310241069
        );
        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Bullet::direction`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_direction(self: @BulletEntity, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                614499057413201613508653200066187686724488589622048075426255068221310241069,
                serialized.span()
            );
    }

    fn get_shot_by(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> ContractAddress {
        let mut values = dojo::model::ModelEntity::<
            BulletEntity
        >::get_member(
            world,
            entity_id,
            588698628524500455708677857476613685638278177895149671674604026323202882523
        );
        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Bullet::shot_by`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_shot_by(
        self: @BulletEntity, world: dojo::world::IWorldDispatcher, value: ContractAddress
    ) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                588698628524500455708677857476613685638278177895149671674604026323202882523,
                serialized.span()
            );
    }
}

#[generate_trait]
pub impl BulletStoreImpl of BulletStore {
    fn entity_id_from_keys(bullet_id: u32) -> felt252 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@bullet_id, ref serialized);

        core::poseidon::poseidon_hash_span(serialized.span())
    }

    fn from_values(ref keys: Span<felt252>, ref values: Span<felt252>) -> Bullet {
        let mut serialized = core::array::ArrayTrait::new();
        serialized.append_span(keys);
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Bullet>::deserialize(ref serialized);

        if core::option::OptionTrait::<Bullet>::is_none(@entity) {
            panic!(
                "Model `Bullet`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Bullet>::unwrap(entity)
    }

    fn get(world: dojo::world::IWorldDispatcher, bullet_id: u32) -> Bullet {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@bullet_id, ref serialized);

        dojo::model::Model::<Bullet>::get(world, serialized.span())
    }

    fn set(self: @Bullet, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Bullet>::set_model(self, world);
    }

    fn delete(self: @Bullet, world: dojo::world::IWorldDispatcher) {
        dojo::model::Model::<Bullet>::delete_model(self, world);
    }


    fn get_coords(world: dojo::world::IWorldDispatcher, bullet_id: u32) -> Vec2 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@bullet_id, ref serialized);

        let mut values = dojo::model::Model::<
            Bullet
        >::get_member(
            world,
            serialized.span(),
            523434579778049082916080710659757700509398103366336840486001269446577652416
        );

        let field_value = core::serde::Serde::<Vec2>::deserialize(ref values);

        if core::option::OptionTrait::<Vec2>::is_none(@field_value) {
            panic!("Field `Bullet::coords`: deserialization failed.");
        }

        core::option::OptionTrait::<Vec2>::unwrap(field_value)
    }

    fn set_coords(self: @Bullet, world: dojo::world::IWorldDispatcher, value: Vec2) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                523434579778049082916080710659757700509398103366336840486001269446577652416,
                serialized.span()
            );
    }

    fn get_speed(world: dojo::world::IWorldDispatcher, bullet_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@bullet_id, ref serialized);

        let mut values = dojo::model::Model::<
            Bullet
        >::get_member(
            world,
            serialized.span(),
            1193789348886335288578152519572796512457833789278870806279892559193678609875
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Bullet::speed`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_speed(self: @Bullet, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                1193789348886335288578152519572796512457833789278870806279892559193678609875,
                serialized.span()
            );
    }

    fn get_direction(world: dojo::world::IWorldDispatcher, bullet_id: u32) -> u32 {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@bullet_id, ref serialized);

        let mut values = dojo::model::Model::<
            Bullet
        >::get_member(
            world,
            serialized.span(),
            614499057413201613508653200066187686724488589622048075426255068221310241069
        );

        let field_value = core::serde::Serde::<u32>::deserialize(ref values);

        if core::option::OptionTrait::<u32>::is_none(@field_value) {
            panic!("Field `Bullet::direction`: deserialization failed.");
        }

        core::option::OptionTrait::<u32>::unwrap(field_value)
    }

    fn set_direction(self: @Bullet, world: dojo::world::IWorldDispatcher, value: u32) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                614499057413201613508653200066187686724488589622048075426255068221310241069,
                serialized.span()
            );
    }

    fn get_shot_by(world: dojo::world::IWorldDispatcher, bullet_id: u32) -> ContractAddress {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@bullet_id, ref serialized);

        let mut values = dojo::model::Model::<
            Bullet
        >::get_member(
            world,
            serialized.span(),
            588698628524500455708677857476613685638278177895149671674604026323202882523
        );

        let field_value = core::serde::Serde::<ContractAddress>::deserialize(ref values);

        if core::option::OptionTrait::<ContractAddress>::is_none(@field_value) {
            panic!("Field `Bullet::shot_by`: deserialization failed.");
        }

        core::option::OptionTrait::<ContractAddress>::unwrap(field_value)
    }

    fn set_shot_by(self: @Bullet, world: dojo::world::IWorldDispatcher, value: ContractAddress) {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(@value, ref serialized);

        self
            .set_member(
                world,
                588698628524500455708677857476613685638278177895149671674604026323202882523,
                serialized.span()
            );
    }
}

pub impl BulletModelEntityImpl of dojo::model::ModelEntity<BulletEntity> {
    fn id(self: @BulletEntity) -> felt252 {
        *self.__id
    }

    fn values(self: @BulletEntity) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.coords, ref serialized);
        core::serde::Serde::serialize(self.speed, ref serialized);
        core::serde::Serde::serialize(self.direction, ref serialized);
        core::serde::Serde::serialize(self.shot_by, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    fn from_values(entity_id: felt252, ref values: Span<felt252>) -> BulletEntity {
        let mut serialized = array![entity_id];
        serialized.append_span(values);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity_values = core::serde::Serde::<BulletEntity>::deserialize(ref serialized);
        if core::option::OptionTrait::<BulletEntity>::is_none(@entity_values) {
            panic!("ModelEntity `BulletEntity`: deserialization failed.");
        }
        core::option::OptionTrait::<BulletEntity>::unwrap(entity_values)
    }

    fn get(world: dojo::world::IWorldDispatcher, entity_id: felt252) -> BulletEntity {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            dojo::model::Model::<Bullet>::selector(),
            dojo::model::ModelIndex::Id(entity_id),
            dojo::model::Model::<Bullet>::layout()
        );
        Self::from_values(entity_id, ref values)
    }

    fn update_entity(self: @BulletEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            dojo::model::Model::<Bullet>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Bullet>::layout()
        );
    }

    fn delete_entity(self: @BulletEntity, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::delete_entity(
            world,
            dojo::model::Model::<Bullet>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Bullet>::layout()
        );
    }

    fn get_member(
        world: dojo::world::IWorldDispatcher, entity_id: felt252, member_id: felt252,
    ) -> Span<felt252> {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Bullet>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::entity(
                    world,
                    dojo::model::Model::<Bullet>::selector(),
                    dojo::model::ModelIndex::MemberId((entity_id, member_id)),
                    field_layout
                )
            },
            Option::None => core::panic_with_felt252('bad member id')
        }
    }

    fn set_member(
        self: @BulletEntity,
        world: dojo::world::IWorldDispatcher,
        member_id: felt252,
        values: Span<felt252>,
    ) {
        match dojo::utils::find_model_field_layout(
            dojo::model::Model::<Bullet>::layout(), member_id
        ) {
            Option::Some(field_layout) => {
                dojo::world::IWorldDispatcherTrait::set_entity(
                    world,
                    dojo::model::Model::<Bullet>::selector(),
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
pub impl BulletModelEntityTestImpl of dojo::model::ModelEntityTest<BulletEntity> {
    fn update_test(self: @BulletEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Bullet>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            self.values(),
            dojo::model::Model::<Bullet>::layout()
        );
    }

    fn delete_test(self: @BulletEntity, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Bullet>::selector(),
            dojo::model::ModelIndex::Id(self.id()),
            dojo::model::Model::<Bullet>::layout()
        );
    }
}

pub impl BulletModelImpl of dojo::model::Model<Bullet> {
    fn get(world: dojo::world::IWorldDispatcher, keys: Span<felt252>) -> Bullet {
        let mut values = dojo::world::IWorldDispatcherTrait::entity(
            world, Self::selector(), dojo::model::ModelIndex::Keys(keys), Self::layout()
        );
        let mut _keys = keys;

        BulletStore::from_values(ref _keys, ref values)
    }

    fn set_model(self: @Bullet, world: dojo::world::IWorldDispatcher) {
        dojo::world::IWorldDispatcherTrait::set_entity(
            world,
            Self::selector(),
            dojo::model::ModelIndex::Keys(Self::keys(self)),
            Self::values(self),
            Self::layout()
        );
    }

    fn delete_model(self: @Bullet, world: dojo::world::IWorldDispatcher) {
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
        self: @Bullet,
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
        "Bullet"
    }

    #[inline(always)]
    fn namespace() -> ByteArray {
        "octoguns"
    }

    #[inline(always)]
    fn tag() -> ByteArray {
        "octoguns-Bullet"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        2993885112008477439600566189474158025957123878196497251489026151309211361625
    }

    #[inline(always)]
    fn instance_selector(self: @Bullet) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn name_hash() -> felt252 {
        2969854501524643226743307162429707250597525878900392288466185200720449112483
    }

    #[inline(always)]
    fn namespace_hash() -> felt252 {
        1924336117031027642112813060054040969607345629178792935276372212332421167173
    }

    #[inline(always)]
    fn entity_id(self: @Bullet) -> felt252 {
        core::poseidon::poseidon_hash_span(self.keys())
    }

    #[inline(always)]
    fn keys(self: @Bullet) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.bullet_id, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Bullet) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.coords, ref serialized);
        core::serde::Serde::serialize(self.speed, ref serialized);
        core::serde::Serde::serialize(self.direction, ref serialized);
        core::serde::Serde::serialize(self.shot_by, ref serialized);

        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::model::Layout {
        dojo::model::introspect::Introspect::<Bullet>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Bullet) -> dojo::model::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        dojo::model::layout::compute_packed_size(Self::layout())
    }
}

#[cfg(target: "test")]
pub impl BulletModelTestImpl of dojo::model::ModelTest<Bullet> {
    fn set_test(self: @Bullet, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::set_entity_test(
            world_test,
            dojo::model::Model::<Bullet>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Bullet>::keys(self)),
            dojo::model::Model::<Bullet>::values(self),
            dojo::model::Model::<Bullet>::layout()
        );
    }

    fn delete_test(self: @Bullet, world: dojo::world::IWorldDispatcher) {
        let world_test = dojo::world::IWorldTestDispatcher {
            contract_address: world.contract_address
        };

        dojo::world::IWorldTestDispatcherTrait::delete_entity_test(
            world_test,
            dojo::model::Model::<Bullet>::selector(),
            dojo::model::ModelIndex::Keys(dojo::model::Model::<Bullet>::keys(self)),
            dojo::model::Model::<Bullet>::layout()
        );
    }
}

#[starknet::interface]
pub trait Ibullet<T> {
    fn ensure_abi(self: @T, model: Bullet);
}

#[starknet::contract]
pub mod bullet {
    use super::Bullet;
    use super::Ibullet;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Bullet>::name()
        }

        fn namespace(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Bullet>::namespace()
        }

        fn tag(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Bullet>::tag()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Bullet>::version()
        }

        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Bullet>::selector()
        }

        fn name_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Bullet>::name_hash()
        }

        fn namespace_hash(self: @ContractState) -> felt252 {
            dojo::model::Model::<Bullet>::namespace_hash()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::model::introspect::Introspect::<Bullet>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Bullet>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::model::Layout {
            dojo::model::Model::<Bullet>::layout()
        }

        fn schema(self: @ContractState) -> dojo::model::introspect::Ty {
            dojo::model::introspect::Introspect::<Bullet>::ty()
        }
    }

    #[abi(embed_v0)]
    impl bulletImpl of Ibullet<ContractState> {
        fn ensure_abi(self: @ContractState, model: Bullet) {}
    }
}
