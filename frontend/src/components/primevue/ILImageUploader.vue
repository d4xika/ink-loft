<script setup>
import { ref, useTemplateRef, watch } from "vue";

const props = defineProps({
  imageSrc: {
    type: String,
    default: null,
  },
  loading: {
    type: Boolean,
    default: false,
  },
  variant: {
    type: String,
    default: "square",
  },
  title: {
    type: String,
    default: "Portrait",
  },
});

const src = ref(props.imageSrc);
const fileUpload = useTemplateRef(null);
const emit = defineEmits(["file-selected", "file-removed"]);

watch(
  () => props.imageSrc,
  (newValue) => {
    if (props.loading) {
      return;
    }
    src.value = newValue;
    if (!newValue && fileUpload.value) {
      fileUpload.value.clear();
    }
  },
);

watch(
  () => props.loading,
  (loading) => {
    if (!loading && props.imageSrc) {
      src.value = props.imageSrc;
    }
  },
);

function onFileSelect(event) {
  const file = event.files[0];
  const reader = new FileReader();

  reader.onload = (e) => {
    src.value = e.target.result;
  };

  reader.readAsDataURL(file);

  emit("file-selected", file);
}

function removeFile(event) {
  event.stopPropagation();
  src.value = null;
  if (fileUpload.value) {
    fileUpload.value.clear();
  }
  emit("file-removed");
}
</script>

<template>
  <div class="uploader-wrapper" :class="`variant-${props.variant}`">
    <div class="relative-container">
      <button
        v-if="src && !loading"
        type="button"
        class="remove-btn"
        @click.stop="removeFile"
      >
        <i class="pi pi-times"></i>
      </button>

      <FileUpload
        ref="fileUpload"
        mode="basic"
        @select="onFileSelect"
        customUpload
        auto
        accept="image/*"
        :disabled="loading"
        class="hidden-uploader"
      >
        <template #chooseicon>
          <div
            class="custom-upload-box"
            :class="{ 'has-image': src }"
            :style="src ? { backgroundImage: `url(${src})` } : {}"
          >
            <div v-if="!src" class="placeholder-content">
              <i class="pi pi-plus"></i>
              <span>{{ props.title }}</span>
            </div>

            <div v-else class="hover-overlay">
              <i class="pi pi-pencil"></i>
            </div>

            <div v-if="loading" class="loading-overlay">
              <span class="spinner"></span>
            </div>
          </div>
        </template>
      </FileUpload>
    </div>
  </div>
</template>

<style scoped lang="scss">
.uploader-wrapper {
  display: flex;
  justify-content: center;

  &.variant-square {
    --fileupload-height: var(--fileupload-square-height);
    --fileupload-width: var(--fileupload-square-width);
  }

  &.variant-rectangle {
    --fileupload-height: var(--fileupload-rectangle-height);
    --fileupload-width: var(--fileupload-rectangle-width);
  }

  .relative-container {
    position: relative;
    width: var(--fileupload-width);
    height: var(--fileupload-height);
  }
}

.remove-btn {
  position: absolute;
  top: -10px;
  right: -10px;
  width: 40px;
  height: 40px;
  color: var(--text-color-1);
  background-color: var(--color-3);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 1;
  transition: all 0.2s ease;

  &:hover {
    transform: scale(1.1);
    background-color: var(--color-3);
  }

  i {
    font-size: var(--font-size-3);
    font-weight: bold;
  }
}

:deep(.hidden-uploader) {
  padding: 0 !important;
  background: transparent !important;
  border: none !important;
  display: block;
  width: var(--fileupload-width);
  height: var(--fileupload-height);
}

.custom-upload-box {
  width: var(--fileupload-width);
  height: var(--fileupload-height);
  border: 2px dashed var(--text-color-1-light);
  border-radius: var(--border-radius-1);
  display: flex;
  align-items: center;
  justify-content: center;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
  transition: background-color 0.3s ease;

  &.has-image {
    border: none;
  }

  &:hover {
    background-color: #262626;
  }

  .placeholder-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: var(--gap-3);
    color: var(--text-color-1);

    i {
      font-size: var(--font-size-6);
    }
    span {
      font-size: var(--font-size-2);
      text-transform: uppercase;
      letter-spacing: 2px;
    }
  }

  .hover-overlay {
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.4);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    color: white;
    transition: opacity 0.2s;
    border-radius: var(--border-radius-1);
  }

  .loading-overlay {
    position: absolute;
    inset: 0;
    background: rgba(0, 0, 0, 0.45);
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: var(--border-radius-1);
    z-index: 2;
  }

  .spinner {
    width: 34px;
    height: 34px;
    border: 3px solid rgba(255, 255, 255, 0.3);
    border-top-color: #fff;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  @media (hover: hover) {
    &:hover .hover-overlay {
      opacity: 1;
    }
  }

  &:active .hover-overlay {
    @media (hover: none) {
      opacity: 1;
      transition: opacit 0.1s;
    }
  }
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
