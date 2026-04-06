<script setup>
import { ref, useTemplateRef } from "vue";

const src = ref(null);
const fileUpload = useTemplateRef(null);
const emit = defineEmits(["file-selected"]);

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
}
</script>

<template>
  <div class="uploader-wrapper">
    <div class="relative-container">
      <button
        v-if="src"
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
              <span>Portrait</span>
            </div>

            <div v-else class="hover-overlay">
              <i class="pi pi-pencil"></i>
            </div>
          </div>
        </template>
      </FileUpload>
    </div>
  </div>
</template>

<style scoped lang="scss">
.uploader-wrapper {
  --fileupload-size: 200px;
  display: flex;
  justify-content: center;

  .relative-container {
    position: relative;
    width: var(--fileupload-size);
    height: var(--fileupload-size);
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
  width: var(--fileupload-size);
  height: var(--fileupload-size);
}

.custom-upload-box {
  width: var(--fileupload-size);
  height: var(--fileupload-size);
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
</style>
