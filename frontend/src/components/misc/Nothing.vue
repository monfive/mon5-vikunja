<template>
	<!-- ponytail: utility classes kept, e2e selects on them -->
	<p class="nothing has-text-centered has-text-grey is-italic p-4 mbe-4">
		<slot />
	</p>
</template>

<style lang="scss" scoped>
.nothing.nothing {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: .75rem;
	padding: 3rem 2rem !important;
	font-style: normal !important;
	color: var(--text-muted) !important;
	font-size: .9375rem;
}
</style>
